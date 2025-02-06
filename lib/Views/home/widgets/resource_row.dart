import 'package:flutter/material.dart';

class ResourceRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color valueColor;
  final VoidCallback onTap;

  const ResourceRow({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.valueColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue), // Icon
            SizedBox(width: 10), // Spacing between icon and text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4), // Spacing between label and value
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}