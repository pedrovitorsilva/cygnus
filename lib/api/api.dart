// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';

import "package:http/http.dart" as http;
import 'package:cygnus/autenticator.dart';

final URL_MAIN = Uri.parse("http://192.168.1.81"); // 192.168.222.237

final URL_PRODUCTS = "${URL_MAIN.toString()}:5001/products";
final URL_PRODUCT = "${URL_MAIN.toString()}:5001/product";
final URL_MAX_PRODUCT = "${URL_MAIN.toString()}:5001/products/max";
final URL_REVIEWS = "${URL_MAIN.toString()}:5002/reviews";
final URL_REVIEWS_ADD = "${URL_MAIN.toString()}:5002/add";
final URL_REVIEWS_REMOVE = "${URL_MAIN.toString()}:5002/remove";

final URL_FILES = "${URL_MAIN.toString()}:5005";

String fileAddress(String file) {
  return "${URL_FILES.toString()}/$file";
}

class ServicesProduct {
  Future<List<dynamic>> getProducts(int lastProduct, int pageSize) async {
    final int page = (lastProduct ~/ pageSize) + 1;
    final answer =
        await http.get(Uri.parse("${URL_PRODUCTS.toString()}/$page/$pageSize"));
    final products = jsonDecode(answer.body);
    return products;
  }

  Future<List<dynamic>> findProducts(
      int lastProduct, int pageSize, String productname) async {
    final int page = (lastProduct ~/ pageSize) + 1;
    final answer = await http.get(
        Uri.parse("${URL_PRODUCTS.toString()}/$page/$pageSize/$productname"));
    final products = jsonDecode(answer.body);
    return products;
  }

  Future<Map<String, dynamic>> findProduct(int id) async {
    final answer = await http.get(Uri.parse("${URL_PRODUCT.toString()}/$id"));
    final product = jsonDecode(answer.body);
    return product;
  }

  Future<int> getMaxProductId() async {
    final answer = await http.get(Uri.parse(URL_MAX_PRODUCT.toString()));
    final product = jsonDecode(answer.body);
    return product['productId'];
  }

  Future<bool> hasMoreItemstoLoad(id) async {
    int currentMax = await getMaxProductId();

    if (currentMax == id) {
      return false;
    }

    return true;
  }
}

class ServicesReviews {
  Future<dynamic> addReview(
      int idProduct, String comment, User user, Double rating) async {
    final answer = await http.post(Uri.parse(
        "${URL_REVIEWS_ADD.toString()}/$idProduct/$comment/${user.email}/${user.name}/$rating"));

    return jsonDecode(answer.body);
  }

  Future<dynamic> removeReview(int idReview) async {
    final answer = await http
        .delete(Uri.parse("${URL_REVIEWS_REMOVE.toString()}/$idReview"));

    return jsonDecode(answer.body);
  }

  Future<List<dynamic>> getReviews(int id) async {
    final answer = await http.get(Uri.parse("${URL_REVIEWS.toString()}/$id"));
    final reviews = jsonDecode(answer.body);
    return reviews;
  }
}