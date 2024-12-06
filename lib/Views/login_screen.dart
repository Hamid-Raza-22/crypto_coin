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
              const SizedBox(height: 20),
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
              const SizedBox(height: 40),
              CustomEditableMenuOption(
                label: 'Email Address',
                initialValue: '',
                onChanged: (value) => _emailController.text = value,
                icon: Icons.mail_outline_rounded,
                iconColor: Colors.blue,

                borderColor: Colors.blueAccent,
              ),
              const SizedBox(height: 1),
              CustomEditableMenuOption(
                label: 'Password',
                initialValue: '',
                onChanged: (value) => _passwordController.text = value,
                icon: Icons.lock_outline_rounded,
                iconColor: Colors.blue,
                borderColor: Colors.blueAccent,
                obscureText: true,
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 50,
          icon: FontAwesomeIcons.facebookF,
          iconColor: Colors.black,
          gradientColors: const [Colors.white, Colors.white],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderColor: Colors.grey,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
        CustomButton(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 50,
          icon: FontAwesomeIcons.google,
          iconColor: Colors.black,
          gradientColors: const [Colors.white, Colors.white],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderColor: Colors.grey,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
        CustomButton(
          width: MediaQuery.of(context).size.width * 0.25,
          height: 50,
          icon: FontAwesomeIcons.apple,
          iconColor: Colors.black,
          gradientColors: const [Colors.white, Colors.white],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderColor: Colors.grey,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
      ],
    );
  }
}
