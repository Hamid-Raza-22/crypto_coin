import 'package:crypto_coin/Components/custom_editable_menu_option.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        imageUrl: logo, // Adjust to the actual logo path
        title: 'Crypto Coin',
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
                  // const SizedBox(height: 20),
                  // const Text(
                  //   'Get started in 3 easy steps',
                  //   style: TextStyle(
                  //     fontFamily: 'Readex Pro',
                  //     fontSize: 30,
                  //     fontWeight: FontWeight.w600,
                  //     height: 1.2,
                  //     color: Colors.black,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  const SizedBox(height: 30),
                  _buildLockImage(),
                  const SizedBox(height: 20),
                  const Text(
                    'Confirm your email',
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
                    'We just sent you an email to xyz@gmail.com',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                     // height: 1.2,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 70),
                  CustomButton(
                    height: 50,
                    borderRadius: 10,
                    buttonText: 'Continue',
                    //icon: Icons.arrow_forward_ios_outlined,
                    //iconPosition: IconPosition.right,
                    iconColor: Colors.white,
                    gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                    onTap: () => Get.offNamed('/StepOneEmailScreen'),
                  ),
                ],
              ),
            ),
          ),

        ],
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
