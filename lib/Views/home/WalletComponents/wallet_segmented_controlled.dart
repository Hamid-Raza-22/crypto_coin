import 'package:flutter/material.dart';

class WalletSegmentedControl extends StatelessWidget {
  final int currentIndex;
  final Function(int) onSegmentChanged;

  WalletSegmentedControl({required this.currentIndex, required this.onSegmentChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.0), // Reduced padding
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => onSegmentChanged(0),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.0), // Adjusted padding
                  backgroundColor: currentIndex == 0 ? Colors.white : Colors.transparent,
                ),
                child: const Text('Cards', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)), // Adjusted font size
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => onSegmentChanged(1),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 8.0), // Adjusted padding
                  backgroundColor: currentIndex == 1 ? Colors.white : Colors.transparent,
                ),
                child: const Text('Portfolio', style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)), // Adjusted font size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
