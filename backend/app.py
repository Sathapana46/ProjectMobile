from flask import Flask,request,jsonify
from flask_cors import CORS
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

# SEARCH ITEM BY QR CODE
@app.route("/items/<code>",methods=["GET"])
def search_item(code):

    db = connect_db()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM items WHERE code LIKE %s",
        (code,)
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

    cursor.execute("SELECT COUNT(*) as repair FROM items WHERE status='ซ่อม'")
    repair = cursor.fetchone()

    return jsonify({
        "total": total["total"],
        "repair": repair["repair"]
    })



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


if __name__ == "__main__":
    app.run(host="0.0.0.0",port=5000)