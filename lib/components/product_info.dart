import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductInfo extends StatelessWidget {
  final dynamic product;
  final String imagePath;

  /// Information over a product.
  /// 
  /// Contains a [mainImage].
  /// 
  /// Constains a [mainData] widget, with name, rating and price.
  const ProductInfo(
      {super.key, required this.product, required this.imagePath});

  Widget mainImage() {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ));
  }

  Widget productName() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 157),
      child: Text(
        product["product"]["name"],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        softWrap: true,
        overflow: TextOverflow.clip,
      ),
    );
  }

  Widget companyName() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        product["company"]["name"],
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  Widget productRating() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RatingBar.builder(
        ignoreGestures: true,
        initialRating: product["rating"].toDouble(),
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 16,
        itemBuilder: (context, _) => const Icon(
          Icons.star,
          color: Color.fromARGB(255, 72, 20, 141),
        ),
        onRatingUpdate: (rating) {
          //
        },
      ),
    );
  }

  Widget productPrice() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        "R\$ ${product["product"]["price"].toString()}",
        textAlign: TextAlign.left,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }

  Widget mainData() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Expanded(
          // Ensure th at the column occupies the remaining space
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          productName(),
          companyName(),
          productRating(),
          productPrice()
        ],
      )),
    );
  }

  Widget productDescription() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(25),
            child: Text(
              product["product"]["description"],
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
          crossAxisAlignment: CrossAxisAlignment
              .start, // Ensure that the row items are aligned to the start
          children: [mainImage(), mainData()]),
      productDescription()
    ]);
  }
}
