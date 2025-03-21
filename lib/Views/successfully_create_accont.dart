import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';

class SuccessfullyCreateAccount extends StatefulWidget {
  const SuccessfullyCreateAccount({super.key});

  @override
  State<SuccessfullyCreateAccount> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<SuccessfullyCreateAccount> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.createPasswordScreen);
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor:    Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          imageUrl: logo,
          title: 'C Coin',
          onBackPressed: () => Get.offNamed(AppRoutes.createPasswordScreen),
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
                      'Congratulations!',
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
                      'You have successfully created a new password, click continue to sign in the application',
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
                      height: 52,
                      borderRadius: 10,
                      buttonText: 'Login',
                      iconColor: Colors.white,
                      gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                      onTap: () => Get.offNamed(AppRoutes.login),
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
        width: 375,
        height: 375,
        child: Image.asset(
          verificationMarkImage,
        ),
      ),
    );
  }
}
