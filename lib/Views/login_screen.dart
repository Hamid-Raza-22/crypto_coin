import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Components/custom_button.dart';
import '../Components/custom_editable_menu_option.dart'; // Import CustomEditableMenuOption

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(
          title: 'Crypto Coin', imageUrl: logo),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              const Text(
                'Login to your Account',
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  height: 1.75,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              CustomEditableMenuOption(
                label: 'Email Address',
                initialValue: '',
                onChanged: (value) => _emailController.text = value,
                icon: Icons.mail_outline_rounded,
                iconColor: Colors.blueAccent,

                borderColor: Colors.blueAccent,
              ),
              const SizedBox(height: 1),
              CustomEditableMenuOption(
                label: 'Password',
                initialValue: '',
                onChanged: (value) => _passwordController.text = value,
                icon: Icons.lock_outline_rounded,
                iconColor: Colors.blueAccent,
                borderColor: Colors.blueAccent,

                obscureText: true,
              ),
              const SizedBox(height: 2),
              CustomEditableMenuOption(
                label: 'Reference Code',
                initialValue: '',
                onChanged: (value) => _passwordController.text = value,
                icon: Icons.lock_outline_rounded,
                iconColor: Colors.blueAccent,
                borderColor: Colors.blueAccent,
                obscureText: false,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 0.1),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password action
                  },
                  child: const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                borderRadius: 10,
                buttonText: 'Sign in with Email',
                icon: Icons.arrow_forward_ios_outlined,
                iconPosition: IconPosition.right,
                iconColor: Colors.white,
                gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                onTap: () => Get.offNamed('/signup'),
              ),
              const SizedBox(height: 40),
              const Text(
                '----------- or continue with -----------',
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.6,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              _buildSocialButtons(context),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    double buttonWidth =50; // Reduced width to make the buttons slimmer
    double buttonHeight = 55.0; // Kept height larger to ensure buttons remain slim and rectangular

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,

      children: [
        SizedBox(width: 30),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SizedBox(
            height: buttonHeight,
            width: buttonWidth,
            child: CustomButton(
               width: buttonWidth,
              height: buttonHeight,
              //iconImage: AssetImage(assetName),
              icon: FontAwesomeIcons.facebookF,
              iconColor: Colors.blueAccent,
              iconSize: 20,
              gradientColors: const [Colors.white, Colors.white],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: 6,
              borderColor: Colors.grey.withOpacity(0.2),
              onTap: () => Get.offNamed('/reportIssues'),
            ),
          ),
        ),
        SizedBox(width: 30), // Add spacing between buttons
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SizedBox(
            height: buttonHeight,
            width: buttonWidth,

            child: CustomButton(
              width: buttonWidth,
              height: buttonHeight,
              iconImage: AssetImage(googleIcon),
              iconImageSize: 20,
              iconColor: Colors.black,
             // iconColor: Color(0xFFDB4437),
              iconSize: 20,
              gradientColors: const [Colors.white, Colors.white],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: 6,
              borderColor: Colors.grey.withOpacity(0.5),
              onTap: () => Get.offNamed('/reportIssues'),
            ),
          ),
        ),
        SizedBox(width: 30), // Add spacing between buttons
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: SizedBox(
            height: buttonHeight,
            width: buttonWidth,

            child: CustomButton(
              width: buttonWidth,
              height: buttonHeight,
              iconSize: 20,
              icon: FontAwesomeIcons.apple,
              iconColor: Colors.black,
              gradientColors: const [Colors.white, Colors.white],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
              borderRadius: 6,
              onTap: () => Get.offNamed('/reportIssues'),
            ),
          ),
        ),
        SizedBox(width: 30), // Add spacing between buttons

      ],
    );
  }



}
