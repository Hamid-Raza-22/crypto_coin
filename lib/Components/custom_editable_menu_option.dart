import 'package:flutter/material.dart';

import 'custom_button.dart';

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
  final Color? borderColor;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final double spacing;
  final IconPosition iconPosition;
  final TextAlign textAlign;

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
    this.borderColor,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor,
    this.iconBackgroundColor,
    this.spacing = 8.0,
    this.iconPosition = IconPosition.left,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    final container = Container(
      width: width ?? double.infinity,
      height: height ?? 60.0,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
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
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: 2.0,
        ),
      ),
      child: Row(
        children: iconPosition == IconPosition.left
            ? _buildIconWithTextField(controller)
            : _buildTextFieldWithIcon(controller),
      ),
    );

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

  List<Widget> _buildIconWithTextField(TextEditingController controller) {
    return [
      if (icon != null) ...[
        Container(
          decoration: BoxDecoration(
            color: iconBackgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Colors.black,
          ),
        ),
        SizedBox(width: spacing),
      ],
      Expanded(
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
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
          ),
          onChanged: onChanged,
        ),
      ),
    ];
  }

  List<Widget> _buildTextFieldWithIcon(TextEditingController controller) {
    return [
      Expanded(
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
      ),
      if (icon != null) ...[
        SizedBox(width: spacing),
        Container(
          decoration: BoxDecoration(
            color: iconBackgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Colors.black,
          ),
        ),
      ],
    ];
  }
}

// enum IconPosition { left, right }
