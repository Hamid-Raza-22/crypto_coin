import 'package:flutter/material.dart';

import '../../Components/custom_appbar.dart';
import '../../Utilities/global_variables.dart';

class TeamScreen extends StatelessWidget {
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
                      'Team',
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

