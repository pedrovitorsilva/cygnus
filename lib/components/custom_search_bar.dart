import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;

  /// Custom SearchBar with [hintText]
  const CustomSearchBar({super.key, 
    required this.controller,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.search),
            hintText: 'Search for Games...',
            // Make text aligned vertically
            contentPadding: EdgeInsets.symmetric(vertical: 0),
          ),
        ),
      ),
    );
  }
}
