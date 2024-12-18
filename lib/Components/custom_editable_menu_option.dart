import 'package:flutter/material.dart';

enum IconPosition { left, right , center}

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
  final ImageProvider? iconImage; // New parameter for iconImage
  final double? iconImageSize; // Size for the iconImage
  final double spacing;
  final IconPosition iconPosition;
  final TextAlign textAlign;
  final bool obscureText;
  final InputBorder? inputBorder;
  final List<BoxShadow>? boxShadow;
  final bool useBoxShadow;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;

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
    this.iconImage, // Initialize iconImage parameter
    this.iconImageSize = 24.0, // Default iconImage size
    this.spacing = 5.0,
    this.iconPosition = IconPosition.left,
    this.textAlign = TextAlign.center,
    this.obscureText = false,
    this.inputBorder,
    this.boxShadow,
    this.useBoxShadow = true,
    this.validator,
    this.keyboardType,
  });

  @override
  _CustomEditableMenuOptionState createState() =>
      _CustomEditableMenuOptionState();
}

class _CustomEditableMenuOptionState extends State<CustomEditableMenuOption> {
  late TextEditingController _controller;
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _obscureText = widget.obscureText;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final container = Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 55.0,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: widget.useBoxShadow
            ? widget.boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(3, 5),
                blurRadius: 6,
              ),
            ]
            : null,
        border: Border.all(
          color: widget.borderColor ?? Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Row(
        children: widget.iconPosition == IconPosition.left
            ? _buildIconOrImageWithTextFieldLeft()
            : _buildTextFieldWithIconOrImageRight(),
      ),
    );

    if (widget.top != null ||
        widget.left != null ||
        widget.right != null ||
        widget.bottom != null) {
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

  List<Widget> _buildIconOrImageWithTextFieldLeft() {
    return [
      if (widget.icon != null || widget.iconImage != null) ...[
        _buildIconOrImage(),
        SizedBox(width: widget.spacing),
      ],
      Expanded(
        child: TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
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
            border: widget.inputBorder ?? InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ),
    ];
  }

  List<Widget> _buildTextFieldWithIconOrImageRight() {
    return [
      Expanded(
        child: TextFormField(
          controller: _controller,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
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
            border: widget.inputBorder ?? InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            suffixIcon: widget.obscureText
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
                color: Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
          ),
          onChanged: widget.onChanged,
          validator: widget.validator,
        ),
      ),
      if (widget.icon != null || widget.iconImage != null) ...[
        SizedBox(width: widget.spacing),
        _buildIconOrImage(),
      ],
    ];
  }

  Widget _buildIconOrImage() {
    if (widget.iconImage != null) {
      return Container(
        width: widget.iconImageSize,
        height: widget.iconImageSize,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.iconImage!,
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      );
    } else if (widget.icon != null) {
      return Container(
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
      );
    }
    return const SizedBox.shrink();
  }
}
