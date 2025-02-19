import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
// import 'package:email_otp/email_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../Components/custom_button.dart';
import '../Components/custom_editable_menu_option.dart';
import '../Components/custom_social_button.dart';
import '../Services/FirebaseServices/send_otp_email.dart';
import '../Services/FirebaseServices/sign_in_with_google.dart';
import '../Services/FirebaseServices/sign_up_with_google.dart';
import '../Services/FirebaseServices/sign_up_with_google.dart';
import '../Services/FirebaseServices/sign_up_with_google.dart';
import '../Services/FirebaseServices/sign_up_with_google.dart';

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
     final bool isOtpSent = await sendOtpEmailHttp(email);

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
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

      appBar: CustomAppBar(
        title: 'C Coin',
        imageUrl: logo,
        onBackPressed: () => Get.offNamed('/ThreeStepLockScreen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
             Text(
              'What’s your email?',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 32,
                fontWeight: FontWeight.w600,
                height: 1.75,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
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
            Text(
              'By registering you accept our Terms & Conditions and Privacy Policy. Your data will be securely encrypted with TLS',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 11,
                fontWeight: FontWeight.w300,
                height: 1.6,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 80),
           Text(
              '----------- or continue with -----------',
              style: TextStyle(
                fontFamily: 'Readex Pro',
                fontSize: 14,
                fontWeight: FontWeight.w300,
                height: 1.6,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            _buildSocialButtons(context),
            const SizedBox(height: 40),
          ],
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
          onTap: signUpWithGoogle
          // onTap: () async {
          //   User? user = await signInWithGoogle();
          //   if( user !=null){
          //     Get.offNamed(AppRoutes.homeScreen);
          //   }else{
          //
          //   }
          // } ,
        ),
        // _buildSocialButton(
        //   icon: FontAwesomeIcons.apple,
        //     color: Colors.black,
        //   onTap: () => Get.offNamed('/reportIssues'),
        // ),
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
