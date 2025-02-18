import 'package:flutter/material.dart';
import 'dart:async';

class AccountActivationScreen extends StatelessWidget {
  void _showActivationDialog(BuildContext context) {
    int countdownDuration = 120; // 2 minutes in seconds
    bool isCloseButtonEnabled = false;

    // Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Start a timer to update the countdown every second
            Timer.periodic(Duration(seconds: 1), (timer) {
              if (countdownDuration > 0) {
                setState(() {
                  countdownDuration--;
                });
              } else {
                timer.cancel(); // Stop the timer when countdown reaches 0
                setState(() {
                  isCloseButtonEnabled = true;
                });
              }
            });

            // Format the countdown time as MM:SS
            String formatTime(int seconds) {
              int minutes = seconds ~/ 60;
              int remainingSeconds = seconds % 60;
              return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
            }

            return AlertDialog(
              title: Text('Account Activation Required'),
              content: Text(
                'Your account is not activated yet. To activate your account, transfer 100 TRX to your current TRON address. After receiving 100 TRX, immediately click on Energy and stake your 100 TRX to avoid network fees. Otherwise, you will incur a cost of 5 to 10 USDT per transaction.',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: isCloseButtonEnabled
                      ? () {
                    Navigator.of(context).pop(); // Close the dialog
                  }
                      : null, // Disable the button until the countdown finishes
                  child: Text(
                    isCloseButtonEnabled ? 'Close' : 'Close (${formatTime(countdownDuration)})',
                    style: TextStyle(
                      color: isCloseButtonEnabled ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Account Activation'),
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,

      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Trigger the dialog box
            _showActivationDialog(context);
          },
          child: Text('Activate Account'),
        ),
      ),
    );
  }
}