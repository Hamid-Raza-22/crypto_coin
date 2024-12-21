import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/custom_button.dart';
import '../Components/custom_editable_menu_option.dart';
import '../Components/custom_social_button.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  CreatePasswordScreenState createState() => CreatePasswordScreenState();
}

class CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late String email;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Get the email from the arguments
    email = Get.arguments?['email'] ?? 'your email';
  }

  Future<void> _registerUser() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    if (password.length < 8 || !RegExp(r'[A-Z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password) || !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password does not meet complexity requirements.')),
      );
      return;
    }

    try {
      // Firebase Authentication registration
      final authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to success screen
      Get.offNamed('/SuccessfullyCreateAccount');
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/VerificationSuccessScreen');
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Crypto Coin',
          imageUrl: logo,
          onBackPressed: () => Get.offNamed('/VerificationSuccessScreen'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                const Text(
                  'Create a password',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 0.5,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'The password must be 8 characters, including 1 uppercase letter, 1 number, and 1 special character.',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomEditableMenuOption(
                  label: 'Password',
                  initialValue: '',
                  onChanged: (value) => _passwordController.text = value,
                  icon: Icons.lock_outline_rounded,
                  iconColor: Colors.blueAccent,
                  borderColor: Colors.blueAccent,
                  obscureText: true,
                ),
                const SizedBox(height: 1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    ' Confirm Password$email',
                    style: const TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      height: 1.6,
                      color: Colors.black87,
                    ),

                  ),
                ),
                const SizedBox(height: 5),

                CustomEditableMenuOption(
                  label: 'Confirm Password',
                  initialValue: '',
                  onChanged: (value) => _confirmPasswordController.text = value,
                  icon: Icons.lock_outline_rounded,
                  iconColor: Colors.blueAccent,
                  borderColor: Colors.blueAccent,
                  obscureText: true,
                ), const SizedBox(height: 10),
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

                const SizedBox(height: 20),

                CustomButton(
                  height: 52,
                  borderRadius: 10,
                  buttonText: 'Continue',
                  gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                  onTap: _registerUser,
                ),
                const SizedBox(height: 10),
                const Text(
                  'By registering you accept our Terms & Conditions and Privacy Policy. Your data will be securely encrypted with TLS.',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                const Text(
                  '----------- or continue with -----------',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSocialButton(
          icon: FontAwesomeIcons.facebookF,
          color: Colors.blue,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
        _buildSocialButton(
          iconImage: AssetImage(googleIcon),
          color: Colors.black,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
        _buildSocialButton(
          icon: FontAwesomeIcons.apple,
          color: Colors.black,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    AssetImage? iconImage,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SocialButton(
      icon: icon,
      iconImage: iconImage,
      color: color,
      onTap: onTap,
    );
  }
}
