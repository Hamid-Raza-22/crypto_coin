import 'dart:io';

import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';
import '../Services/FirebaseServices/sign_up_with_google.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static const double _horizontalPadding = 20.0;
  static const double _verticalSpacing = 10.0;
  static const double _buttonHeight = 55.0;
  static const double _buttonWidthFactor = 0.9;
  static const double _bottomPaddingFactor = 0.05;
  static const double _sidePaddingFactor = 0.08;
  static const double _borderRadius = 15.0;
  static const double _socialButtonHeightFactor = 0.07;
  static const double _iconSize = 25;
  static const double _iconSpacing = 10;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUpWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);
        await auth.signInWithCredential(credential);
        Get.offNamed('/dashboard');
      } else {
        print('Facebook Sign-Up Failed: ${result.message}');
      }
    } catch (e) {
      print('Facebook Sign-Up Error: $e');
    }
  }


  Future<void> _signUpWithApple() async {
    try {
      final AuthorizationCredentialAppleID appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final AuthCredential credential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      await auth.signInWithCredential(credential);
      Get.offNamed('/dashboard');
    } catch (e) {
      print('Apple Sign-In Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  CustomAppBar(
        imageUrl: logo, // Adjust to the actual logo path
        title: 'Crypto Coin',
        onBackPressed: () {exit(0);
          // Handle back button action
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Hello! Start your crypto investment today',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      height: 1.75,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  _buildSocialButton(
                    context: context,
                    text: 'Continue with Facebook',
                    iconImage: AssetImage(facebookIcon),

                    onTap: _signUpWithFacebook,
                  ),
                  const SizedBox(height: 10),
                  _buildSocialButton(
                    context: context,
                    text: 'Continue with Google',
                    iconImage: AssetImage(googleIcon),
                     onTap: signUpWithGoogle,
                  ),
                  const SizedBox(height: 10),
                  _buildSocialButton(
                    context: context,
                    text: 'Continue with Apple',
                    icon: FontAwesomeIcons.apple,
                    onTap: _signUpWithApple,
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    width: screenSize.width * _buttonWidthFactor,
                    height: 55,

                    buttonText: 'Sign up with Email',
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                    onTap: () => Get.offNamed(AppRoutes.threeStepLockScreen),
                    borderRadius: 15.0,
                  ),
                  const SizedBox(height: 55),
                  const Center(
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: screenSize.height * _bottomPaddingFactor,
              left: screenSize.width * _sidePaddingFactor,
              right: screenSize.width * _sidePaddingFactor,
            ),
            child: CustomButton(
              width: screenSize.width * 0.9,
              height: 55,
              buttonText: 'Sign In',
              textStyle: const TextStyle(
                color: Colors.blueAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              gradientColors: const [Colors.white, Colors.white],
              onTap: () => Get.offNamed(AppRoutes.login),
              borderRadius: 15.0,
              borderColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String text,
    final IconData? icon,
    final iconImage,
    required VoidCallback onTap,
  }) {
    final screenSize = MediaQuery.of(context).size;

    return CustomButton(
      width: screenSize.width,
      height: screenSize.height * _socialButtonHeightFactor,
      buttonText: text,
      iconImage: iconImage,
      icon: icon,
      iconSize: 25,
      iconColor: Colors.black,
      spacing: 10,
      textAlign: TextAlign.left,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      gradientColors: const [Colors.white, Colors.white],
      onTap: onTap,
      borderRadius: 15.0,
    );
  }
}
