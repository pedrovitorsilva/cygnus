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
    connection = mysql.connect(host=DB_SERVER, user=DB_USER, password=DB_PASSWORD, database=DB_DATABASE_NAME)

    return connection

URL_RATING = "http://rating:5000/rating_by_feed/"
def get_rating(feed_id):
    url = URL_RATING + str(feed_id)
    answer = urlopen(url)
    answer = answer.read()
    answer = json.loads(answer)

    return answer["rating"]

@servico.get("/info")
def get_info():
    return jsonify(
        descricao = "products - cygnus",
        versao = "1.0"
    )

@servico.get("/products/<int:page>/<int:page_size>")
def get_products(page, page_size):
    products = []

    connection = get_connection_db()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        # "SELECT feeds.id as product_id, DATE_FORMAT(feeds.data, '%Y-%m-%d %H:%i') as data, " +
        # "empresas.id as empresa_id, empresas.nome as nome_empresa, empresas.avatar, products.nome as nome_product, products.descricao, FORMAT(products.preco, 2) as preco, " +
        # "products.url, products.imagem1, IFNULL(products.imagem2, '') as imagem2, IFNULL(products.imagem3, '') as imagem3 " +
        # "FROM feeds, products, empresas " +
        # "WHERE products.id = feeds.product " +
        # "AND empresas.id = products.empresa " +
        # "ORDER BY data desc " +
        # "LIMIT " + str((pagina - 1) * tamanho_da_pagina) + ", " + str(tamanho_da_pagina)
    )
    products = cursor.fetchall()
    if products:
        for p in products:
            p["rating"] = get_rating(p['_id']) # product_id

    connection.close()

    return jsonify(products)

@servico.get("/products/<int:pagina>/<int:tamanho_da_pagina>/<string:nome_do_product>")
def find_products(page, page_size, product_name):
    products = []

    connection = get_connection_db()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        # "select feeds.id as product_id, DATE_FORMAT(feeds.data, '%Y-%m-%d %H:%i') as data, " +
        # "empresas.id as empresa_id, empresas.nome as nome_empresa, empresas.avatar, products.nome as nome_product, products.descricao, FORMAT(products.preco, 2) as preco, " +
        # "products.url, products.imagem1, IFNULL(products.imagem2, '') as imagem2, IFNULL(products.imagem3, '') as imagem3 " +
        # "FROM feeds, products, empresas " +
        # "WHERE products.id = feeds.product " +
        # "AND empresas.id = products.empresa " +
        # "AND products.nome LIKE '%" + nome_do_product + "%' "  +
        # "ORDER BY data desc " +
        # "LIMIT " + str((pagina - 1) * tamanho_da_pagina) + ", " + str(tamanho_da_pagina)
    )
    products = cursor.fetchall()
    if products:
        for p in products:
            p["rating"] = get_rating(p['_id'])  # product_id

    connection.close()

    return jsonify(products)

@servico.get("/product/<int:feed_id>")
def find_product(feed_id):
    product = {}

    connection = get_connection_db()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        # "select feeds.id as product_id, DATE_FORMAT(feeds.data, '%Y-%m-%d %H:%i') as data, " +
        # "empresas.id as empresa_id, empresas.nome as nome_empresa, empresas.avatar, products.nome as nome_product, products.descricao, FORMAT(products.preco, 2) as preco, " +
        # "products.url, products.imagem1, IFNULL(products.imagem2, '') as imagem2, IFNULL(products.imagem3, '') as imagem3 " +
        # "FROM feeds, products, empresas " +
        # "WHERE products.id = feeds.product " +
        # "AND empresas.id = products.empresa " +
        # "AND feeds.id = " + str(feed_id)
    )
    product = cursor.fetchone()
    if product:
        product["rating"] = get_rating(feed_id)

    connection.close()

    return jsonify(product)


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)