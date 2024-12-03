import 'package:flutter/material.dart';

class CustomEditableMenuOption extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const CustomEditableMenuOption({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    final container = Container(
      width: width ?? double.infinity, // Default to full width if not provided
      height: height ?? 60.0, // Default height if not provided
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
        ),
        onChanged: onChanged,
      ),
    );

    // If positioning is required
    if (top != null || left != null || right != null || bottom != null) {
      return Positioned(
        top: top,
        left: left,
        right: right,
        bottom: bottom,
        child: container,
      );
    }

    return container;
  }
}
