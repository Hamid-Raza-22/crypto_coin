import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Components/otp_inputs.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:email_otp/email_otp.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Components/custom_button.dart';
import '../Components/custom_social_button.dart';
import '../Services/FirebaseServices/send_otp_email.dart';
import '../Services/FirebaseServices/sign_in_with_google.dart';

class EmailCodeScreen extends StatefulWidget {
  const EmailCodeScreen({super.key});

  @override
  StepOneEmailScreenState createState() => StepOneEmailScreenState();
}

class StepOneEmailScreenState extends State<EmailCodeScreen> {
  late String email;
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Get the email from the arguments
    email = Get.arguments?['email'] ?? 'your email';
  }
  Future<void> _verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    try {
      bool isValid = await verifyOtpEmailHttp(email, otpController.text);
      // bool isValid = await EmailOTP.verifyOTP(otp: otpController.text);
      if (isValid) {
        Get.offNamed(AppRoutes.verificationSuccessScreen, arguments: {'email':email});
      } else {
        _showSnackbar('Invalid OTP. Please try again.', isError: true);
      }
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      _showSnackbar('An error occurred. Please try again later.', isError: true);
    } finally {
      setState(() {
        isLoading = false;
      });
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
      duration: const Duration(seconds: 4),
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.confirmEmailScreen);
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor:   Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'C Coin',
          imageUrl: logo,
          onBackPressed: () => Get.offNamed(AppRoutes.confirmEmailScreen),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                Text(
                  'Please enter the code',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    height: 1.75,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'We sent email to $email',
                  style:  TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildLockImage(),
                const SizedBox(height: 30),
                CustomEditableOTPInput(
                  length: 6,
                  controller: otpController, // Bind the controller
                ),
                const SizedBox(height: 2),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Handle forgot password action
                    },
                    child: const Text(
                      'Didn\'t get a mail? Send again',
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
                  height: 50,
                  borderRadius: 10,
                  buttonText: isLoading ? 'Please wait...': 'Entered',
                  iconColor: Colors.white,
                  gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                  onTap: isLoading ? null : _verifyOTP,
                ),

                const SizedBox(height: 40),
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
        ),
      ),
    );
  }

  Widget _buildLockImage() {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        child: Image.asset(
          messageImage,
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
            color:Colors.black,
          onTap: () async {
            User? user = await signInWithGoogle();
            if( user !=null){
              Get.offNamed(AppRoutes.homeScreen);
            }else{

            }
          } ,
        ),
        _buildSocialButton(
          icon: FontAwesomeIcons.apple,
            color:Colors.black,
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