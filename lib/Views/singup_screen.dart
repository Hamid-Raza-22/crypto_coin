import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        imageUrl: logo, // Adjust to the actual logo path
        title: 'Crypto Coin',
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                    icon: FontAwesomeIcons.facebookF,
                    onTap: () => Get.offNamed('/facebookLogin'),
                  ),
                  const SizedBox(height: 10),
                  _buildSocialButton(
                    context: context,
                    text: 'Continue with Google',
                    icon: FontAwesomeIcons.google,
                    onTap: () => Get.offNamed('/googleLogin'),
                  ),
                  const SizedBox(height: 10),
                  _buildSocialButton(
                    context: context,
                    text: 'Continue with Apple',
                    icon: FontAwesomeIcons.apple,
                    onTap: () => Get.offNamed('/appleLogin'),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    width: screenSize.width * 0.9,
                    height: 55,
                    buttonText: 'Sign up with Email',
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                    onTap: () => Get.offNamed('/emailSignup'),
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
              bottom: screenSize.height * 0.05,
              left: screenSize.width * 0.08,
              right: screenSize.width * 0.08,
            ),
            child: CustomButton(
              width: screenSize.width * 0.9,
              height: 55,
              buttonText: 'Sign In',
              textStyle: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              gradientColors: const [Colors.white, Colors.white],
              onTap: () => Get.offNamed('/login'),
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
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final screenSize = MediaQuery.of(context).size;

    return CustomButton(
      width: screenSize.width,
      height: screenSize.height * 0.07,
      buttonText: text,
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
