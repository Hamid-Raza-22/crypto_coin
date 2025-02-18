import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? imageUrl; // Dynamic parameter for the image URL
  final VoidCallback? onBackPressed; // Optional callback for back button

  const CustomAppBar({
    super.key,
    this.title,
    this.imageUrl, // Initialize the image URL
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

      title: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the entire row
        crossAxisAlignment: CrossAxisAlignment.center, // Aligns image and text vertically centered
       // spacing: 5,
        children: [
          Flexible(
            child: Image.asset(
                imageUrl ?? "",
                height: 24, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
          ),
         SizedBox(
           width: 5,
         ),
         Padding(
           padding: const EdgeInsets.only(right: 50.0),
            child:  Text(
            title ?? "",
            style: TextStyle(
              fontFamily: 'Readex Pro',
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.indigoAccent,
            ),
          ),)
        ],
      ),
      centerTitle: true,

      elevation: 0,
      leading: onBackPressed != null
          ? IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey.withOpacity(0.8)),
        onPressed: onBackPressed,
      )
          : null, // Only show the back button if onBackPressed is provided
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
