import 'package:crypto_coin/Components/custom_editable_menu_option.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';

class ConfirmEmailScreen extends StatefulWidget {

  @override
  State<ConfirmEmailScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<ConfirmEmailScreen> {
late String email;
@override
void initState() {
  super.initState();
  // Get the email from the arguments
  email = Get.arguments?['email'] ?? 'your email';
}
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.stepOneEmailScreen);
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor:   Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          imageUrl: logo, // Adjust to the actual logo path
          title: 'C Coin',
          onBackPressed: () => Get.offNamed(AppRoutes.stepOneEmailScreen),
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
                    const SizedBox(height: 30),
                    _buildLockImage(),
                    const SizedBox(height: 20),
                    Text(
                      'Confirm your email',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                     Text(
                      'We just sent you an email to $email',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 70),
                    CustomButton(
                      height: 50,
                      borderRadius: 10,
                      buttonText: 'Continue',
                      iconColor: Colors.white,
                      gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                      onTap: () => Get.offNamed(AppRoutes.emailCodeScreen, arguments: {'email': email}),
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
      child: Container(
        width: 375,
        height: 375,
        child: Image.asset(
          mobileEmail,
        ),
      ),
    );
  }
}
