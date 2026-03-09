import mysql.connector

def connect_db():

    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="",
        database="asset_system",
        charset="utf8mb4"
    )