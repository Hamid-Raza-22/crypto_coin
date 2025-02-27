import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/custom_appbar.dart';
import '../../Utilities/global_variables.dart';
import '../../Components/custom_button.dart';
import 'dart:io' show Platform;

class ChannelScreen extends StatelessWidget {
  // Function to launch the Telegram channel link

  Future<void> _launchTelegramChannel() async {
    const String telegramLink = "https://t.me/+1lAv9emLNsM3NWE9";

    try {
      // Check if the URL can be launched
      if (await canLaunch(telegramLink)) {
        await launch(telegramLink);
      } else {
        // Fallback to opening in a browser
        throw 'Could not launch $telegramLink';
      }
    } catch (e) {
      // Show an error message or fallback behavior
      print("Error launching URL: $e");

      // Fallback to opening in a browser
      if (Platform.isAndroid) {
        await launch(telegramLink, forceSafariVC: false);
      } else if (Platform.isIOS) {
        await launch(telegramLink, forceSafariVC: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

      appBar: CustomAppBar(
        title: "C Coin",
        imageUrl: logo,
        // onBackPressed: ,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Channel link for the Telegram',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.75,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 200),
                    Center(
                      child: Text(
                        'Here we put the channel link for the Telegram',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20), // Added space between text and button
                    CustomButton(
                      width: 150,
                      height: 50,
                      spacing: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      icon: Icons.open_in_new,
                      // iconPosition: IconPosition.right,
                      iconColor: Colors.white,
                      iconSize: 20,
                      buttonText: 'Join Channel',
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.bold,
                      ),
                      gradientColors: [Colors.blueAccent, Colors.blueAccent],
                      onTap: _launchTelegramChannel, // Link the onTap to the function
                      borderRadius: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}