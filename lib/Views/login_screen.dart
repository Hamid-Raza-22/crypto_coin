import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Services/FirebaseServices/sign_in_with_google.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Components/custom_button.dart';
import '../Components/custom_editable_menu_option.dart';
import '../Components/custom_social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _signInUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both email and password.')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        // Firebase Authentication sign-in
        final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // If successful, navigate to the home screen
        Get.offNamed(AppRoutes.homeScreen); // Replace with your home screen route
        return;
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException code: ${e.code}');
        if (e.code != 'network-request-failed' || retryCount == maxRetries - 1) {
          String errorMessage;

          switch (e.code) {
            case 'invalid-email':
              errorMessage = 'The email address is badly formatted.';
              break;
            case 'user-disabled':
              errorMessage = 'This user account has been disabled.';
              break;
            case 'user-not-found':
              errorMessage = 'No user found with this email.';
              break;
            case 'wrong-password':
              errorMessage = 'Incorrect password.';
              break;
            case 'invalid-credential':
              errorMessage = 'The email or password is incorrect.';
              break;
            case 'network-request-failed':
              errorMessage = 'No internet connection. Please check your network and try again.';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many unsuccessful attempts. Please try again later.';
              break;
            default:
              errorMessage = 'An error occurred. Please try again.';
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
          break;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
        print('Error: $e');
        break;
      }

      // Wait before retrying
      await Future.delayed(retryDelay);
      retryCount++;
    }

    setState(() {
      isLoading = false;
    });
  }

// Future<void>homepage()async{
//   // Get.offNamed('/HomeScreen'); // Replace with your home screen route
//   Get.offNamed(AppRoutes.homepage); // Replace with your home screen route
//
// }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.signup);
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Crypto Coin',
          imageUrl: logo,
          onBackPressed: () => Get.offNamed(AppRoutes.signup),
        ),
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
                const SizedBox(height: 10),
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
                      // Navigate to forgot password screen
                      Get.toNamed('/forgotPassword'); // Update with your forgot password route
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
                const SizedBox(height: 5),
                CustomButton(
                  borderRadius: 10,
                  buttonText: isLoading ? 'Please wait...':'Sign in',
                  gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                  onTap: isLoading ? null :_signInUser,
                  // onTap: _signInUser,
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
