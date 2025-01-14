import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../Components/custom_button.dart';
import '../Components/custom_editable_menu_option.dart';

class StepOneEmailScreen extends StatefulWidget {
  const StepOneEmailScreen({super.key});

  @override
  StepOneEmailScreenState createState() => StepOneEmailScreenState();
}

class StepOneEmailScreenState extends State<StepOneEmailScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  bool _isEmailValid(String email) {
    final RegExp emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email) && email.contains('@') && email.endsWith('.com');
  }
  Future<void> _verifyEmail() async {
    final String email = _emailController.text.trim();

    if (!_isEmailValid(email)) {
      _showSnackbar('Please enter a valid email address', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'temporaryPassword',
      );

      await result.user!.delete();
      final bool isOtpSent = await EmailOTP.sendOTP(email: email);

      if (isOtpSent) {
        _showSnackbar('OTP has been sent to your email');
        await Future.delayed(Duration(seconds: 2));
        Get.offNamed(AppRoutes.confirmEmailScreen, arguments: {'email': email});
      } else {
        _showSnackbar('Failed to send OTP.', isError: true);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _showSnackbar('Email is already registered. Log in instead.');
        Get.offNamed(AppRoutes.login);
      } else {
        _showSnackbar('Error: ${e.message}', isError: true);
      }
    } catch (e) {
      _showSnackbar('Unexpected error occurred: $e', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    Get.snackbar(
      'Notification',
      message,
      icon: Icon(
        isError ? Icons.warning : Icons.verified_user,
        color: isError ? Colors.white : Colors.white,
        size: 30,
      ),
      backgroundColor: isError ? Colors.red : Colors.blueAccent,
      colorText: Colors.white,
      borderRadius: 10,
      padding: const EdgeInsets.all(20),
      duration: const Duration(seconds: 7),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Crypto Coin',
        imageUrl: logo,
        onBackPressed: () => Get.offNamed('/ThreeStepLockScreen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            const Text(
              'What’s your email?',
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
            const SizedBox(height: 2),
            TextButton(
              onPressed: () => Get.offNamed('/LoginScreen'),
              child: const Text(
                'Have an account? Log in here',
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 1.6,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 50),
            CustomButton(
              height: 50,
              borderRadius: 10,
              buttonText: _isLoading ? 'Please wait...' : 'Continue',
              iconColor: Colors.white,
              gradientColors: const [Colors.blueAccent, Colors.blueAccent],
              onTap: _isLoading ? null : _verifyEmail,
            ),
            const SizedBox(height: 40),
            const Text(
              'By registering you accept our Terms & Conditions and Privacy Policy. Your data will be securely encrypted with TLS',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 11,
                fontWeight: FontWeight.w300,
                height: 1.6,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
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
            _buildSocialButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButtons() {
    const double buttonHeight = 55.0;
    const double buttonWidth = 50.0;
    return
    Padding(padding: EdgeInsets.symmetric(horizontal: 35),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      // crossAxisAlignment: CrossAxisAlignment,
      spacing: 20,

      children: [

        _buildSocialButton(
          icon: FontAwesomeIcons.facebookF,
          iconColor: Colors.blueAccent,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
        _buildSocialButton(
          iconImage: const AssetImage(googleIcon),
          onTap: () => Get.offNamed('/reportIssues'),
        ),
        _buildSocialButton(
          icon: FontAwesomeIcons.apple,
          iconColor: Colors.black,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
      ],)
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    AssetImage? iconImage,
    Color iconColor = Colors.grey,
    required VoidCallback onTap,
  }) {
    return Flexible(
      flex: 1,
      fit: FlexFit.tight,
      child: SizedBox(
        height: 55.0,

        child: CustomButton(
          width: 50.0,
          height: 55.0,
          icon: icon,
          iconSize: 20,
          iconImageSize: 20,
          iconImage: iconImage,
          iconColor: iconColor,
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
          onTap: onTap,
        ),
      ),
    );
  }
}
