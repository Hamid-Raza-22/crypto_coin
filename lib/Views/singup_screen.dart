import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';
import '../Services/FirebaseServices/sign_in_with_facebook.dart';
import '../Services/FirebaseServices/sign_in_with_google.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> with TickerProviderStateMixin {
  // late AnimationController _fadeController;
  // late Animation<double> _fadeAnimation;
  // late AnimationController _slideController;
  // late Animation<Offset> _slideAnimation;
  // late AnimationController _buttonController;
  // late Animation<double> _buttonAnimation;

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // _fadeController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // _fadeAnimation =
    //     CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    // _slideController =
    //     AnimationController(vsync: this, duration: const Duration(seconds: 2));
    // _slideAnimation =
    //     Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero)
    //         .animate(
    //         CurvedAnimation(parent: _slideController, curve: Curves.easeInOut));
    // _buttonController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 1000));
    // _buttonAnimation =
    //     CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut);
    // _fadeController.forward();
    // _slideController.forward();
    // _buttonController.forward();
  }

  @override
  void dispose() {
    // _fadeController.dispose();
    // _slideController.dispose();
    // _buttonController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Future<void> _signUpWithEmail() async {
  //   try {
  //     await _auth.createUserWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //     // Save user data to Firestore
  //     await FirebaseFirestore.instance.collection('UserWithEmailAndPassword').doc(_emailController.text).set({
  //       // 'town_name': _nameController.text,
  //       // 'town_address': _addressController.text,
  //       // 'owner_name': _ownerController.text,
  //       'email': _emailController.text,
  //       'password': _passwordController.text,
  //       // 'image': imageUrl,
  //       // 'phone': _contactNumberController.text, // Storing phone number
  //     });
  //
  //     Get.snackbar(" Login Successful", "", backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
  //     Get.offNamed('/login');
  //   } catch (e) {
  //     Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        imageUrl: logo,
        title: 'Crypto Coin',
       // onBackPressed: () => Get.offNamed('/home'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
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
                    ),
                    const SizedBox(height: 10),
                    buildCustomButton(
                      context: context,
                      buttonText: 'Continue with Facebook',
                      icon: FontAwesomeIcons.facebookF,
                      gradientColors: [Colors.white, Colors.white],
                      onTap: () => Get.offNamed('/login'),
                    ),
                    const SizedBox(height: 10),
                    buildCustomButton(
                      context: context,
                      buttonText: 'Continue with Google',
                      icon: FontAwesomeIcons.google,
                      gradientColors: [Colors.white, Colors.white],
                      onTap: () => Get.offNamed(''),
                    ),
                    const SizedBox(height: 10),
                    buildCustomButton(
                      context: context,
                      buttonText: 'Continue with Apple',
                      icon: FontAwesomeIcons.apple,
                      gradientColors: [Colors.white, Colors.white],
                      onTap: () => Get.offNamed(''),
                    ),
                    const SizedBox(height: 10),
                    CustomButton(
                      bottom: MediaQuery.of(context).size.height * 0.03,
                      top: MediaQuery.of(context).size.height * 0.759,
                      left: MediaQuery.of(context).size.width * 0.06,
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 55,
                      buttonText: 'Sign up with Email',
                      iconSize: 20,
                      iconColor: Colors.black,
                      iconPosition: IconPosition.right,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                      onTap: () {
                        Get.offNamed('/login');
                        print("loginnnn");
                      },
                      borderRadius: 15.0,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          offset: const Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    const SizedBox(height: 90),
                    const Center(
                      child: Text(
                        'Already have an account?',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.75,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.05,
              left: MediaQuery.of(context).size.width * 0.06,
              child: CustomButton(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 55,
                buttonText: 'Sign In',
                iconSize: 20,
                iconColor: Colors.black,
                iconPosition: IconPosition.right,
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
      ),


    );
  }

  CustomButton buildCustomButton({
    required BuildContext context,
    required String buttonText,
    required IconData icon,
    required VoidCallback onTap,
    IconPosition iconPosition = IconPosition.left,
    Color? iconColor,
    List<Color> gradientColors = const [Colors.white, Colors.white],

  }) {
    return CustomButton(

      width: MediaQuery
          .of(context)
          .size
          .width * 1.2,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.07,
      buttonText: buttonText,
      icon: icon,
      iconSize: 25,
      spacing: 1,
      iconColor: iconColor,
      iconPosition: iconPosition,
      textAlign: TextAlign.left,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      gradientColors: gradientColors,
      onTap: onTap,
      borderRadius: 15.0,
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.blue.withOpacity(0.3),
      //     offset: const Offset(0, 5),
      //     blurRadius: 10,
      //   ),
      // ],
      iconBackgroundColor: Colors.white, // New parameter
    );
  }
}