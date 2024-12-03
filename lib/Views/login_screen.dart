
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';


import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';
import '../Components/custom_editable_menu_option.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});



  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
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
      appBar: CustomAppBar(
        imageUrl: logo,
        title: 'Crypto Coin',
        // onBackPressed: () => Get.offNamed('/home'),
      ),
      body: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height,
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
                      child:  Text(
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

                    ),
                    const SizedBox(height: 10),
                    CustomEditableMenuOption(
                      width: MediaQuery.of(context).size.width * 0.9,
                      left: MediaQuery.of(context).size.width * 0.05,
                      borderColor: Colors.blue,
                      icon: Icons.mail_outline_rounded,
                      iconColor: Colors.blue,
                      iconPosition: IconPosition.left,

                      height: 60,
                      label: 'Email Address',
                      initialValue: '',
                      onChanged: (value) {
                        print('Email Address updated to: $value');
                      },
                    ),
                    const SizedBox(height: 1),
                    CustomEditableMenuOption(
                      width: MediaQuery.of(context).size.width * 0.9,
                      left: MediaQuery.of(context).size.width * 0.02,
                      borderColor: Colors.blue,
                      icon: Icons.lock_outline_rounded,
                     // icon: FontAwesomeIcons.lock,
                      iconColor: Colors.blue,
                      iconPosition: IconPosition.left,
                      height: 60,
                      label: 'Password',
                      initialValue: '',
                      onChanged: (value) {
                        print('Password updated to: $value');
                      },
                    ),
                    const SizedBox(height: 10),

                    const Center(
                      child:  Text(
                        'Forgot your password? Click here',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          height: 1.6,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      bottom: MediaQuery
                          .of(context)
                          .size
                          .height * 0.03,
                      top: MediaQuery
                          .of(context)
                          .size
                          .height * 0.759,
                      left: MediaQuery
                          .of(context)
                          .size
                          .width * 0.06,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.9,
                      height: 55,
                      buttonText: 'Sign up with Email',
                      //icon: Icons.arrow_forward_ios_outlined,
                      iconSize: 20,
                      iconColor: Colors.black,
                      iconPosition: IconPosition.right,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                      onTap: () => Get.offNamed('/reportIssues'),
                      borderRadius: 15.0,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.1),
                          offset: const Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                      //iconBackgroundColor: Colors.white, // New parameter
                    ),
                    const SizedBox(height: 100),
                    const Center(
                      child:  Text(
                        'or continue with',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                          height: 1.6,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.05,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.75,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.1,
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.68,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.2,
              height: 50,
              //buttonText: 'Sign In',
               icon: FontAwesomeIcons.facebookF,
              iconSize: 25,
              iconColor: Colors.black,
              iconPosition: IconPosition.left,

              // textStyle: const TextStyle(
              //   color: Colors.black,
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              // ),
              gradientColors: const [Colors.white,Colors.white],
              onTap: () => Get.offNamed('/reportIssues'),
              borderRadius: 15.0,
              borderColor: Colors.grey,

              // boxShadow: [
              //   // BoxShadow(
              //   //   color: Colors.blue.withOpacity(0.3),
              //   //   offset: const Offset(0, 5),
              //   //   blurRadius: 10,
              //   // ),
              // ],
              //iconBackgroundColor: Colors.white, // New parameter
            ),
            const SizedBox(width: 5),
            CustomButton(
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.05,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.75,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.35,
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.44,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.3,
              height: 50,
              //buttonText: 'Sign In',
              icon: FontAwesomeIcons.google,
              iconSize: 25,
              iconColor: Colors.black,
              iconPosition: IconPosition.left,

              // textStyle: const TextStyle(
              //   color: Colors.black,
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              // ),
              gradientColors: const [Colors.white,Colors.white],
              onTap: () => Get.offNamed('/reportIssues'),
              borderRadius: 15.0,
              borderColor: Colors.grey,

              // boxShadow: [
              //   // BoxShadow(
              //   //   color: Colors.blue.withOpacity(0.3),
              //   //   offset: const Offset(0, 5),
              //   //   blurRadius: 10,
              //   // ),
              // ],
              //iconBackgroundColor: Colors.white, // New parameter
            ),
            const SizedBox(width: 5),
            CustomButton(
              bottom: MediaQuery
                  .of(context)
                  .size
                  .height * 0.05,
              top: MediaQuery
                  .of(context)
                  .size
                  .height * 0.75,
              left: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6,
              right: MediaQuery
                  .of(context)
                  .size
                  .width * 0.2,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.3,
              height: 50,
              //buttonText: 'Sign In',
              icon: FontAwesomeIcons.apple,
              iconSize: 25,
              iconColor: Colors.black,
              iconPosition: IconPosition.left,

              // textStyle: const TextStyle(
              //   color: Colors.black,
              //   fontSize: 20,
              //   fontWeight: FontWeight.bold,
              // ),
              gradientColors: const [Colors.white,Colors.white],
              onTap: () => Get.offNamed('/reportIssues'),
              borderRadius: 15.0,
              borderColor: Colors.grey,

              // boxShadow: [
              //   // BoxShadow(
              //   //   color: Colors.blue.withOpacity(0.3),
              //   //   offset: const Offset(0, 5),
              //   //   blurRadius: 10,
              //   // ),
              // ],
              //iconBackgroundColor: Colors.white, // New parameter
            ),
          ],

        ),
      ),
    );
  }

  CustomButton buildCustomButton({
    //  required BuildContext context,
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