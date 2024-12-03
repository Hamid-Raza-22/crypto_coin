import 'package:flutter/material.dart';

class CustomManuOption extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final String title;
  final VoidCallback onTap;

  const CustomManuOption({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity, // Default to full width if not provided
        height: height ?? 60.0,

        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(3, 5),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
