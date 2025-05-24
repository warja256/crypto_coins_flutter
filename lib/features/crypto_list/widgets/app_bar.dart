import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomAppBar extends StatelessWidget {
  final TextEditingController controller;
  final String title;

  const CustomAppBar(
      {super.key, required this.controller, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ),
        const SizedBox(height: 9),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 39,
            decoration: BoxDecoration(
              color: const Color(0xFF232336),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(),
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Color(0xFFE4E4F0)),
                      cursorColor: Color(0xFFE4E4F0),
                      decoration: const InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        hintText: 'Search...',
                        hintStyle: TextStyle(color: Color(0xFFE4E4F0)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.search, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
