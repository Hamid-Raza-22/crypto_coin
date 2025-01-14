import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Components/custom_editable_menu_option.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:flutter/material.dart';

import '../../Components/custom_button.dart';

class ChannelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Crypto Coin",
        imageUrl: logo,
        //onBackPressed: ,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: 20),
                    Text(
                      'Channel link for the WhatsApp',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.75,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 200),
                    Center(
                      child: Text(
                        'Here we put the channel link for the whatsapp',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20), // Added space between text and button
                    CustomButton(
                      width: 150,
                      height: 50,
                      spacing: 0,
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                      icon: Icons.open_in_new,
                      iconPosition: IconPosition.right,
                      iconColor: Colors.white,
                      iconSize: 20,
                      buttonText: 'Join Channel',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.bold,
                      ),
                      gradientColors: [Colors.blueAccent, Colors.blueAccent],
                      // onTap: () => Get.offNamed(AppRoutes.threeStepLockScreen),
                      borderRadius: 15.0,
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
}
