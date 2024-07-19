from flask import Flask, jsonify
from urllib.request import urlopen
import mysql.connector as mysql
import json

servico = Flask("products")

DB_SERVER = "database"
DB_USER = "root"
DB_PASSWORD = "admin"
DB_DATABASE_NAME = "cygnus"


def get_connection_db():
    connection = mysql.connect(
        host=DB_SERVER, user=DB_USER, password=DB_PASSWORD, database=DB_DATABASE_NAME)

    return connection


@servico.get("/info")
def get_info():
    return jsonify(
        data="products - cygnus",
    )


@servico.get("/products/<int:page>/<int:page_size>")
def get_products(page, page_size):
    products = []

    connection = get_connection_db()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f'''SELECT p.id as productId,
        p.name as name,
        p.description as description,
        p.price as price,
        p.companyName as companyName,
        p.companyAvatar as companyAvatar,
        r.rating as rating
        FROM products p
        JOIN rating r on p.id=r.product_id
        LIMIT {str((page - 1) * page_size)}, {page_size}'''
    )
    products = cursor.fetchall()

    connection.close()

    return jsonify(products)


@servico.get("/products/<int:page>/<int:page_size>/<string:product_name>")
def find_products(page, page_size, product_name):
    products = []

    connection = get_connection_db()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f'''SELECT p.id as productId,
        p.name as name,
        p.description as description,
        p.price as price,
        p.companyName as companyName,
        p.companyAvatar as companyAvatar,
        r.rating as rating
        FROM products p
        JOIN rating r on p.id=r.product_id
        WHERE p.name LIKE "%{product_name}%"
        LIMIT {str((page - 1) * page_size)}, {page_size}'''
    )
    products = cursor.fetchall()

    connection.close()

    return jsonify(products)


@servico.get("/product/<int:feed_id>")
def find_product(feed_id):
    product = {}

    connection = get_connection_db()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f'''SELECT p.id as productId,
        p.name as name,
        p.description as description,
        p.price as price,
        p.companyName as companyName,
        p.companyAvatar as companyAvatar,
        r.rating as rating
        FROM products p
        JOIN rating r on p.id=r.product_id
        WHERE p.id = {feed_id}'''
    )
    product = cursor.fetchone()

    connection.close()

    return jsonify(product)


@servico.get("/products/max")
def find_max_product():
    product = {}

    connection = get_connection_db()

    cursor = connection.cursor(dictionary=True)
    cursor.execute("SELECT MAX(p.id) as productId FROM products p")
    product = cursor.fetchone()

    connection.close()

    return jsonify(product)


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)
