import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Kanit',
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: Colors.white.withOpacity(0.8),
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.8)),
        onPressed: onBackPressed,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
