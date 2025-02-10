import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Utilities/global_variables.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

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

    // Navigate to home page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
       Get.offNamed(AppRoutes.signup);
      //Get.offNamed(AppRoutes.homeScreen);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      backgroundColor: Colors.white, // Set background color to black for modern feel
      body: FadeTransition(
        opacity: _fadeInAnimation, // Apply fade-in effect for smooth transition
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: logoTopPadding), // Dynamic padding for top alignment
              Image.asset(
                logo,
               // height: logoHeight, // Logo size based on screen height
              ),
              // SizedBox(height: screenHeight * 0.05), // Space between image and text
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
                    // TextSpan(
                    //   text: 'SCOOTERS', // Second part in green
                    //   style: TextStyle(
                    //     fontFamily: 'Inter',
                    //     fontSize: mainTextSize, // Matching size for second part
                    //     fontWeight: FontWeight.bold,
                    //     color: Color(0xFF00F27E), // Bright green for contrast
                    //     height: 1.3,
                    //   ),
                    // ),
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


