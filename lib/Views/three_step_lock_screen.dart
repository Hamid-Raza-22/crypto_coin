import 'package:crypto_coin/Components/custom_editable_menu_option.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';

class ThreeStepLockScreen extends StatefulWidget {
  @override
  State<ThreeStepLockScreen> createState() => _ThreeStepLockScreenState();
}

class _ThreeStepLockScreenState extends State<ThreeStepLockScreen> {
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

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed('/signup');
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          imageUrl: logo,
          title: 'Crypto Coin',
          onBackPressed: () => Get.offNamed(AppRoutes.signup),
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
                      'Get started in 3 easy steps',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _buildLockImage(),
                    const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(

                            FontAwesomeIcons.one,
                            size: 21,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Create your account',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            FontAwesomeIcons.two,
                            size: 21,
                            color: Colors.blueAccent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Account verification',
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    CustomButton(
                      height: 50,
                      borderRadius: 10,
                      buttonText: 'Continue',
                      iconColor: Colors.white,
                      gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                      onTap: () => Get.offNamed(AppRoutes.stepOneEmailScreen),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLockImage() {
    return Center(
      child: SizedBox(
        width: 322,
        height: 284,
        child: Image.asset(
          lockImage,
        ),
      ),
    );
  }
}
