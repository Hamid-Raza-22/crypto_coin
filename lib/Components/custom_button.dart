import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final dynamic buttonText;
  final TextStyle? textStyle;
  final VoidCallback onTap;
  final double borderRadius;
  final List<Color> gradientColors;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final IconData? icon; // Parameter for icon
  final double? iconSize; // Icon size
  final Color? iconColor; // Icon color
  final Color? iconBackgroundColor; // Icon background color
  final double spacing; // Spacing between icon and text
  final IconPosition iconPosition; // Icon position (left or right)
  final TextAlign textAlign; // New parameter for text alignment

  const CustomButton({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.buttonText,
    required this.onTap,
    this.textStyle,
    this.borderRadius = 20.0,
    this.gradientColors = const [Color(0xFF00C853), Color(0xFF64DD17)],
    this.boxShadow,
    this.margin,
    this.padding,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor,
    this.iconBackgroundColor, // Optional icon background color
    this.spacing = 8.0,
    this.iconPosition = IconPosition.left, // Default position is left
    this.textAlign = TextAlign.center, // Default text alignment is center
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: width ?? MediaQuery.of(context).size.width * 0.9,
          height: height ?? 60.0,
          margin: margin,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: boxShadow ?? [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: iconPosition == IconPosition.left
                  ? _buildIconWithTextLeft()
                  : _buildIconWithTextRight(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIconWithTextLeft() {
    return [
      if (icon != null) ...[
        if (iconBackgroundColor != null)
          Container(
            width: 58,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Colors.black,
            ),
          )
        else
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Colors.black,
          ),
        SizedBox(width: spacing),
      ],
      if (buttonText != null)
        Expanded(
          child: Text(
            buttonText,
            textAlign: textAlign, // Apply the text alignment
            style: textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
    ];
  }

  List<Widget> _buildIconWithTextRight() {
    return [
      if (buttonText != null)
        Expanded(
          child: Text(
            buttonText,
            textAlign: textAlign, // Apply the text alignment
            style: textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      SizedBox(width: spacing),
      if (icon != null) ...[
        if (iconBackgroundColor != null)
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                 topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? Colors.black,
            ),
          )
        else
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? Colors.black,
          ),
      ],
    ];
  }
}

enum IconPosition { left, right } // Enum for icon position
