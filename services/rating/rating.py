from flask import Flask, jsonify
import mysql.connector as mysql

servico = Flask("rating")

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
        data="rating - cygnus",
    )


@servico.get("/rating_by_id/<int:id>")
def rating_by_product(id):
    conexao = get_connection_db()
    cursor = conexao.cursor(dictionary=True)
    cursor.execute(
        f"SELECT rating as value FROM rating WHERE id={id}"
    )

    rating = cursor.fetchone()

    conexao.close()

    return jsonify(rating_number=rating["value"])


@servico.get("/update_rating")
def update_rating():

    conexao = get_connection_db()
    cursor = conexao.cursor()
    cursor.execute(
        f''' UPDATE rating r
    JOIN (
        SELECT product_id, ROUND(AVG(user_rating), 2) AS average_rating
        FROM reviews
        GROUP BY product_id
    ) avg_ratings
    ON r.product_id = avg_ratings.product_id
    SET r.rating = avg_ratings.average_rating
    '''
    )
    conexao.commit()
    conexao.close()

    return jsonify({"message": "Ratings updated successfully"}), 200


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)
