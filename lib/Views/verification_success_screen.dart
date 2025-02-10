import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Components/custom_appbar.dart';
import '../Components/custom_button.dart';

class VerificationSuccessScreen extends StatefulWidget {
  const VerificationSuccessScreen({super.key});

  @override
  State<VerificationSuccessScreen> createState() => _ConfirmEmailScreenState();
}

class _ConfirmEmailScreenState extends State<VerificationSuccessScreen> {
  late String email;
  @override
  void initState() {
    super.initState();
    // Get the email from the arguments
    email = Get.arguments?['email'] ?? 'your email';
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.emailCodeScreen);
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          imageUrl: logo,
          title: 'C Coin',
          onBackPressed: () => Get.offNamed(AppRoutes.emailCodeScreen),
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
                    const Text(
                      'Verification Success',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Congratulations your account is ready to use, now you can start trading cryptocurrency',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 70),
                    CustomButton(
                      height: 52,
                      borderRadius: 10,
                      buttonText: 'Create Password',
                      iconColor: Colors.white,
                      gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                      onTap: () => Get.offNamed('/CreatePasswordScreen',arguments: {'email':email}),
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
