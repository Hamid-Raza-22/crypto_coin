import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? imageUrl; // New dynamic parameter for the image URL
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
  this.title,
     this.imageUrl, // Initialize the image URL
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Flexible(
        child:
          Image.asset(
            imageUrl?? "",
            height:24, // Adjust the height as needed
            fit: BoxFit.cover,
          ),),
          SizedBox(width:5), // Space between image and text
          Text(
            title??"",
            style: TextStyle(
              fontFamily: 'Kanit',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.indigoAccent,
            ),
          ),
        ],
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      // elevation: 0,
      // leading: IconButton(
      //   icon: Icon(Icons.arrow_back, color: Colors.white.withOpacity(0.8)),
      //   onPressed: onBackPressed,
      // ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
