import 'package:flutter/material.dart';
import 'package:cygnus/state.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cygnus/api/api.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;

  /// Card model for each product on [main_feed] page.
  ///
  /// Contains an Image, Company Name, Company Icon,
  /// Product Name, Rating, Price and Details Button
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    String productId = product["productId"].toString();
    String imagePath = "product$productId.jpeg";

    String companyAvatar = product["companyAvatar"];

    return GestureDetector(
      onTap: () {
        stateApp.showProduct(product["productId"]);
      },
      child: Card(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Image.network(
              fileAddress(imagePath),
              height: 130,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 15,
                    child: Image.network(
                      fileAddress(companyAvatar),
                      width: 24,
                    ),
                  ),
                ),
                Text(
                  product["companyName"],
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                product["name"],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              )
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "R\$ ${product['price'].toString()}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 8),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RatingBar.builder(
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
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 6, left: 15, right: 15),
              child: Card(
                color: Color.fromARGB(255, 92, 8, 228),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.5, horizontal: 15),
                  child: Text(
                    'Click for Details',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
