import 'package:flutter/material.dart';

class CustomEditableMenuOption extends StatefulWidget {
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
  final bool obscureText; // New parameter for obscuring text

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
    this.obscureText = false, // Default value for obscuring text
  });

  @override
  _CustomEditableMenuOptionState createState() => _CustomEditableMenuOptionState();
}

class _CustomEditableMenuOptionState extends State<CustomEditableMenuOption> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: widget.initialValue);

    final container = Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 60.0,
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
          color: widget.borderColor ?? Colors.transparent,
          width: 2.0,
        ),
      ),
      child: Row(
        children: widget.iconPosition == IconPosition.left
            ? _buildIconWithTextField(controller)
            : _buildTextFieldWithIcon(controller),
      ),
    );

    if (widget.top != null || widget.left != null || widget.right != null || widget.bottom != null) {
      return Positioned(
        top: widget.top,
        left: widget.left,
        right: widget.right,
        bottom: widget.bottom,
        child: container,
      );
    }

    return container;
  }

  List<Widget> _buildIconWithTextField(TextEditingController controller) {
    return [
      if (widget.icon != null) ...[
        Container(
          decoration: BoxDecoration(
            color: widget.iconBackgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.iconColor ?? Colors.black,
          ),
        ),
        SizedBox(width: widget.spacing),
      ],
      Expanded(
        child: TextField(
          controller: controller,
          obscureText: _obscureText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 4),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    ];
  }

  List<Widget> _buildTextFieldWithIcon(TextEditingController controller) {
    return [
      Expanded(
        child: TextField(
          controller: controller,
          obscureText: _obscureText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.blue,),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
          onChanged: widget.onChanged,
        ),
      ),
      if (widget.icon != null) ...[
        SizedBox(width: widget.spacing),
        Container(
          decoration: BoxDecoration(
            color: widget.iconBackgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.iconColor ?? Colors.black,
          ),
        ),
      ],
    ];
  }
}

enum IconPosition { left, right }
