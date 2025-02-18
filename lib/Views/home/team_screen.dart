import 'package:flutter/material.dart';
import '../../Components/custom_appbar.dart';
import '../../Utilities/global_variables.dart';

class TeamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme
      appBar: const CustomAppBar(
        title: "C Coin",
        imageUrl: logo,
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
                      'Team',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.75,
                        color: Theme.of(context).textTheme.bodyMedium?.color, // Theme-based color
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 200),
                    Center(
                      child: Text(
                        'Here we put the channel link for the whatsapp',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyMedium?.color, // Theme-based color
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20), // Added space between text and button
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