from flask import Flask,request,jsonify
from flask_cors import CORS

import pandas as pd
from db import connect_db
from flask import send_from_directory
from flask import make_response
import os

app = Flask(__name__)
CORS(app)

UPLOAD_FOLDER = os.path.join(os.getcwd(), "uploads")
os.makedirs(UPLOAD_FOLDER,exist_ok=True)

# LOGIN
@app.route("/login",methods=["POST"])
def login():

    data = request.json

    username = data["username"]
    password = data["password"]

    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM users WHERE username=%s AND password=%s",
        (username,password)
    )

    user = cursor.fetchone()

    if user:
        return jsonify({
            "status":"success",
            "user":user
        })

    return jsonify({
        "status":"error"
    })
@app.route("/register", methods=["POST"])
def register():

    data = request.json

    username = data["username"]
    password = data["password"]
    fullname = data["fullname"]

    db = connect_db()
    cursor = db.cursor()

    cursor.execute(
        """
        INSERT INTO users(username,password,fullname,role)
        VALUES(%s,%s,%s,'user')
        """,
        (username,password,fullname)
    )

    db.commit()

    return jsonify({"status":"success"})
# GET USERS
@app.route("/users",methods=["GET"])
def get_users():

    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT * FROM users")

    users = cursor.fetchall()

    return jsonify(users)

# GET ALL ITEMS
@app.route("/items",methods=["GET"])
def get_items():

    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT * FROM items")

    items = cursor.fetchall()

    return jsonify(items)

@app.route("/import-items", methods=["POST"])
def import_items():

    if "file" not in request.files:
        return jsonify({"status":"error","message":"no file"})

    file = request.files["file"]

    # ตรวจชนิดไฟล์
    if file.filename.endswith(".csv"):
        df = pd.read_csv(file)
    else:
        df = pd.read_excel(file, engine="openpyxl")

    db = connect_db()
    cursor = db.cursor()

    for index, row in df.iterrows():

        cursor.execute(
            """
            INSERT INTO items(name,type,code,status,location,image)
            VALUES(%s,%s,%s,%s,%s,%s)
            """,
            (
                row["name"],
                row["type"],
                row["code"],
                row["status"],
                row["location"],
                ""
            )
        )

    db.commit()

    return jsonify({
        "status":"success",
        "rows": len(df)
    })
# SEARCH ITEM BY QR CODE (support slashes)

@app.route("/items/<path:code>", methods=["GET"])
def search_item(code):

    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM items WHERE code=%s",
        (code,)
    )

    item = cursor.fetchone()

    if item:
        return jsonify(item)

    return jsonify({"status":"not found"})


@app.route("/item/<int:id>", methods=["GET"])
def get_item(id):

    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM items WHERE id=%s",
        (id,)
    )

    item = cursor.fetchone()

    if item:
        return jsonify(item)

    return jsonify({"status":"not found"})

# ADD ITEM
@app.route("/add-item",methods=["POST"])
def add_item():

    name = request.form["name"]
    type = request.form["type"]
    code = request.form["code"]
    status = request.form["status"]
    location = request.form["location"]

    image_file = request.files.get("image")

    filename = ""

    if image_file:

        filename = image_file.filename
        path = os.path.join(UPLOAD_FOLDER,filename)

        image_file.save(path)

    db = connect_db()
    cursor = db.cursor()

    cursor.execute(
        """
        INSERT INTO items(name,type,code,status,location,image)
        VALUES(%s,%s,%s,%s,%s,%s)
        """,
        (name,type,code,status,location,filename)
    )

    db.commit()

    return jsonify({"status":"success"})

@app.route("/uploads/<path:filename>")
def uploaded_file(filename):
    response = make_response(send_from_directory("uploads", filename))
    response.headers["ngrok-skip-browser-warning"] = "true"
    return response

# UPDATE ITEM
@app.route("/update-item/<id>",methods=["PUT"])
def update_item(id):

    data = request.json

    db = connect_db()
    cursor = db.cursor()

    cursor.execute(
        """
        UPDATE items
        SET name=%s,type=%s,status=%s,location=%s,code=%s
        WHERE id=%s
        """,
        (
            data["name"],
            data["type"],
            data["status"],
            data["location"],
            data["code"],
            id
        )
    )

    db.commit()

    return jsonify({"status":"updated"})

@app.route("/dashboard")
def dashboard():

    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) as total FROM items")
    total = cursor.fetchone()

    cursor.execute("SELECT COUNT(*) as repair FROM items WHERE status='ชำรุดรอซ่อม'") 
    repair = cursor.fetchone()

    return jsonify({
        "total": total["total"],
        "repair": repair["repair"]
    })

@app.route('/add-user', methods=['POST'])
def add_user():

    data = request.json

    username = data['username']
    password = data['password']
    role = data['role']

    db = connect_db()
    cursor = db.cursor()

    cursor.execute(
        "INSERT INTO users (username,password,role) VALUES (%s,%s,%s)",
        (username,password,role)
    )

    db.commit()

    return jsonify({"status":"success"})

@app.route('/update-user/<int:id>', methods=['PUT'])
def update_user(id):

    data = request.json

    username = data['username']
    role = data['role']

    db = connect_db()
    cursor = db.cursor()

    cursor.execute(
        "UPDATE users SET username=%s, role=%s WHERE id=%s",
        (username, role, id)
    )

    db.commit()

    return jsonify({"status":"success"})

@app.route('/delete-user/<int:id>', methods=['DELETE'])
def delete_user(id):

    db = connect_db()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM users WHERE id=%s",
        (id,)
    )

    db.commit()

    return jsonify({"status":"deleted"})

# DELETE ITEM
@app.route("/delete-item/<id>",methods=["DELETE"])
def delete_item(id):

    db = connect_db()
    cursor = db.cursor()

    cursor.execute(
        "DELETE FROM items WHERE id=%s",
        (id,)
    )

    db.commit()

    return jsonify({"status":"deleted"})




@app.route("/import-users", methods=["POST"])
def import_users():

    if "file" not in request.files:
        return jsonify({"status":"error","message":"no file"})

    file = request.files["file"]

    if file.filename.endswith(".csv"):
        df = pd.read_csv(file)
    else:
        df = pd.read_excel(file, engine="openpyxl")

    db = connect_db()
    cursor = db.cursor()

    for index,row in df.iterrows():

        cursor.execute(
            """
            INSERT INTO users(username,password,role)
            VALUES(%s,%s,%s)
            """,
            (
                row["username"],
                row["password"],
                row["role"]
            )
        )

    db.commit()

    return jsonify({
        "status":"success",
        "rows": len(df)
    })

if __name__ == "__main__":
    print(app.url_map)
    app.run(host="0.0.0.0",port=5000)