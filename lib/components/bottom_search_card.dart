import 'package:flutter/material.dart';

class BottomSearchCard extends StatelessWidget {
  final TextEditingController controller;
  const BottomSearchCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          style: TextStyle(fontSize: 18, color: Color.fromRGBO(31, 31, 31, 1)),
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Search...',
            // Add a clear button to the search bar
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.clear, color: Color.fromRGBO(31, 31, 31, 1)),
                  onPressed: () {
                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
