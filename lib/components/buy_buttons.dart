import 'package:flutter/material.dart';

Card getCygnusPassButton = Card(
  margin: const EdgeInsets.all(10),
  child: OverflowBar(
    alignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      TextButton(
        child: const Text(
          'Get Cygnus Pass',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ),
    ],
  ),
);

Card buyButton = Card(
  color: const Color.fromARGB(255, 184, 54, 244),
  margin: const EdgeInsets.all(10),
  child: OverflowBar(
    alignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      TextButton(
        child: const Text(
          'Buy Now',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
      ),
    ],
  ),
);

/// An area with a [getCygnusPassButton] and a [buyButton]
Padding buttonAreas = Padding(
  padding: const EdgeInsets.only(top: 15, bottom: 30),
  child: Column(children: [
    getCygnusPassButton,
    buyButton
  ]),
);
