import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/global_variables.dart'; // Import shared preferences


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;


  Future<void> getKeysFromPreferences() async {
    try {
      // Step 1: Retrieve the SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Step 2: Get the keys from SharedPreferences
      publicKey = prefs.getString('tronAddressRef');
      privateKey = prefs.getString('tronPrivateKeyRef');

      if (publicKey == null || privateKey == null) {
        throw Exception("Keys not found in SharedPreferences.");
      }

      // Step 3: Assign the keys to variables
      print("Public Key from Preferences: $publicKey");
      print("Private Key from Preferences: $privateKey");

      // Step 4: Use the variables (example usage)
      // For demonstration, let's just print them
      print("Using Public Key: $publicKey");
      print("Using Private Key: $privateKey");

      // You can now use `publicKey` and `privateKey` in your app logic
    } catch (e) {
      print("Error retrieving keys from SharedPreferences: $e");
    }
  }
  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // Start the animation
    _controller.forward();

    // Check login state after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      bool isLoggedIn = await _checkLoginState(); // Check if user is logged in
      if (isLoggedIn) {
        await getKeysFromPreferences();
        Get.offNamed(AppRoutes.homeScreen); // Navigate to HomeScreen if logged in
      } else {
        Get.offNamed(AppRoutes.policyDialog); // Navigate to Signup screen if not logged in
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to check login state from shared preferences
  Future<bool> _checkLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false; // Default to false if not set
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery to get the size of the device screen
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Adjust sizes and padding dynamically
    final logoHeight = screenHeight * 0.25; // Logo takes 25% of screen height
    final mainTextSize = screenWidth * 0.07; // Main text is 7% of screen width
    final subtitleTextSize = screenWidth * 0.045; // Subtitle is 4.5% of screen width
    final spacingBetweenText = screenHeight * 0.02; // Dynamic spacing between texts
    final logoTopPadding = screenHeight * 0.2; // Dynamic padding for logo

    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme
 // Set background color to white
      body: FadeTransition(
        opacity: _fadeInAnimation, // Apply fade-in effect for smooth transition
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: logoTopPadding), // Dynamic padding for top alignment
              Image.asset(
                logo,
                height: logoHeight, // Logo size based on screen height
              ),
              SizedBox(height: 10), // Space between image and text
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'C Coin', // First part of the text
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: mainTextSize, // Dynamic font size for main text
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacingBetweenText), // Dynamic space between texts
              SizedBox(height: screenHeight * 0.15), // Space at the bottom to keep balance
            ],
          ),
        ),
      ),
    );
  }
}