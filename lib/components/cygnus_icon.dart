import 'package:flutter/material.dart';

class CygnusIcon extends StatelessWidget {
  /// Main Icon from App
  const CygnusIcon({super.key});

  

  @override
  Widget build(BuildContext context) {
    return 
    Image.asset(
      "lib/resources/icons/cygnus.png",
      height: 40,
      color: Colors.white,
    );
  }
}
