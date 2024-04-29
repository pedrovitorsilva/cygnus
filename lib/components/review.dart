import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Review extends StatelessWidget {
  final dynamic item;

  /// Review element, used in product page.
  /// 
  /// Used inside [flatList] elements.
  /// 
  /// Contains a user image, name, rating, and comment.
  const Review({super.key, required this.item});

  // Components
  final Padding anonymousIcon = const Padding(
    padding: EdgeInsets.all(6),
    child: Icon(
      Icons.account_circle_rounded,
      size: 35,
    ),
  );

  Widget nameAndRating(dynamic item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            item["user"]["name"],
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 6),
            child: RatingBar.builder(
              ignoreGestures: true,
              initialRating: item["rating"].toDouble(),
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 12,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Color.fromARGB(255, 72, 20, 141),
              ),
              onRatingUpdate: (rating) {
                //
              },
            ))
      ],
    );
  }

  Widget reviewComment(dynamic item) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        item["comment"],
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  // Main
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        child: Column(
          children: [
            Row(
              children: [anonymousIcon, nameAndRating(item)],
            ),
            Row(children: [reviewComment(item)])
          ],
        ),
      ),
    );
  }
}
