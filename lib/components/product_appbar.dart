import 'package:cygnus/components/cygnus_icon.dart';
import 'package:cygnus/state.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
AppBar product_appBar = AppBar(
    title: Row(
  children: [
    GestureDetector(
      onTap: () {
        stateApp.showMain();
      },
      child: const Icon(Icons.arrow_back, size: 30),
    ),
    const Padding(
      padding: EdgeInsets.only(left: 10.0),
      child: Text(
        "Back",
        style: TextStyle(fontSize: 15, color: Colors.white),
      ),
    ),
    const Expanded(
      child: Align(alignment: Alignment.centerRight, child: CygnusIcon()),
    ),
  ],
));
