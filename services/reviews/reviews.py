from flask import Flask, jsonify, request
import mysql.connector as mysql
import requests

servico = Flask("reviews")

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
        data="reviews - cygnus",
    )


URL_REVIEW_UPDATE = "http://rating:5000/update_rating"
def update_rating():
    requests.get(URL_REVIEW_UPDATE)
    return jsonify({"message": "Ratings updated successfully"}), 200


@servico.get("/reviews/<int:id>")
def get_reviews(id):

    update_rating()
    reviews = []

    connection = get_connection_db()
    cursor = connection.cursor(dictionary=True)
    cursor.execute(
        f'''SELECT id as review_id,
        product_id,
        user_id,
        user_name,
        user_email,
        user_rating,
        user_comment
        FROM reviews
        WHERE product_id = {id}'''
    )

    reviews = cursor.fetchall()
    connection.close()

    return jsonify(reviews)


@servico.route('/add', methods=['POST'])
def add_review():
    result = jsonify(status="ok", error="")

    data = request.json
    product_id = data.get("product_id")
    comment = data.get("comment")
    email = data.get("email")
    username = data.get("username")
    rating = data.get("rating")

    connection = get_connection_db()
    cursor = connection.cursor()
    try:
        cursor.execute(
            "INSERT INTO reviews (product_id, user_comment, user_email, user_name, user_rating) VALUES (%s, %s, %s, %s, %s)",
            (product_id, comment, email, username, rating)
        )
        connection.commit()
    except Exception as e:
        connection.rollback()
        result = jsonify(status="error", error=str(e))

    finally:
        connection.close()
        update_rating()
    
    return result

    # return result


@servico.delete("/remove/<int:review_id>")
def remove_review(review_id):
    result = jsonify(status="ok", erro="")

    connection = get_connection_db()
    cursor = connection.cursor()
    try:
        cursor.execute(
            f"DELETE FROM reviews WHERE id = {review_id}"
        )
        connection.commit()
    except:
        connection.rollback()
        result = jsonify(status="erro", erro="erro removendo o review")

    finally:
        connection.close()
        update_rating()

    return result


if __name__ == "__main__":
    servico.run(host="0.0.0.0", debug=True)
