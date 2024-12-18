import 'package:flutter/material.dart';

import 'custom_editable_menu_option.dart';



class CustomButton extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final dynamic buttonText;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final double borderRadius;
  final List<Color> gradientColors;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final ImageProvider? iconImage; // New parameter for iconImage
  final double? iconImageSize; // New parameter for iconImage size
  final double spacing;
  final IconPosition iconPosition;
  final TextAlign textAlign;
  final Color? borderColor;

  const CustomButton({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    this.width,
    this.height,
    this.buttonText,
    this.onTap,
    this.textStyle,
    this.borderRadius = 20.0,
    this.gradientColors = const [Color(0xFF00C853), Color(0xFF64DD17)],
    this.boxShadow,
    this.margin,
    this.padding,
    this.icon,
    this.iconSize = 24.0,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconImage, // Initialize iconImage
    this.iconImageSize = 24.0, // Default iconImage size
    this.spacing = 8.0,
    this.iconPosition = IconPosition.left,
    this.textAlign = TextAlign.center,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width * 0.9,
        height: height ?? 55.0,
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
          border: Border.all(
            color: borderColor ?? Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: iconPosition == IconPosition.left
                ? _buildIconOrImageWithTextLeft()
                : _buildIconOrImageWithTextRight(),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIconOrImageWithTextLeft() {
    return [
      if (icon != null || iconImage != null) ...[
        _buildIconOrImage(),
        SizedBox(width: spacing),
      ],
      if (buttonText != null)
        Expanded(
          child: Text(
            buttonText,
            textAlign: textAlign,
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

  List<Widget> _buildIconOrImageWithTextRight() {
    return [
      if (buttonText != null)
        Expanded(
          child: Text(
            buttonText,
            textAlign: textAlign,
            style: textStyle ??
                const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      SizedBox(width: spacing),
      if (icon != null || iconImage != null) ...[
        _buildIconOrImage(),
      ],
    ];
  }

  Widget _buildIconOrImage() {
    if (iconImage != null) {
      return Container(
        width: iconImageSize,
        height: iconImageSize,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: iconImage!,
            fit: BoxFit.contain,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      );
    } else if (icon != null) {
      return Icon(
        icon,
        size: iconSize,
        color: iconColor ?? Colors.black,
      );
    }
    return const SizedBox.shrink();
  }
}
