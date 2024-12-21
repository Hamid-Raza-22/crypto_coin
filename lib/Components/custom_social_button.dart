import 'package:flutter/material.dart';

import 'custom_button.dart';

class SocialButton extends StatelessWidget {
  final IconData? icon;
  final AssetImage? iconImage;
  final Color color;
  final VoidCallback onTap;

  const SocialButton({
    Key? key,
    this.icon,
    this.iconImage,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: CustomButton(
        width: 60,
        height: 60,
        icon: icon,
        iconImageSize: 20,
        iconBackgroundColor: Colors.black54,
        iconImage: iconImage,
        iconColor: color,
        gradientColors: const [Colors.white, Colors.white],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: 8,
        onTap: onTap,
      ),
    );
  }
}
