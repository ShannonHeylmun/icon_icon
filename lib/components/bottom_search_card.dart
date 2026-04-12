import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icon_icon/theme_bloc.dart';

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
          style: TextStyle(
            fontSize: 18,
            color: context.read<ThemeBloc>().state is ThemeDark
                ? Colors.white
                : Color.fromRGBO(31, 31, 31, 1),
          ),
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
