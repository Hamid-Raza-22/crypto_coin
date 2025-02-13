import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

late AnimationController _fadeController;
late Animation<double> _fadeAnimation;

late AnimationController _slideController;
late Animation<Offset> _slideAnimation;

late AnimationController _buttonController;
late Animation<double> _buttonAnimation;
// Main Color
const Color buttonColorGreen = Color(0xFF00F27E);
// Images
final FirebaseAuth auth = FirebaseAuth.instance;

const hamidImage = "assets/images/Hamid2.jpg";
const logo = "assets/images/logo.png";
const lockImage = "assets/images/lock.png";
const messageImage = "assets/images/message.png";
const mobileEmail = "assets/images/mobileEmail.png";
const verificationMarkImage = "assets/images/verificationMark.png";
const transactionMarkImage = "assets/images/TransactionSuccess.png";


// Icons
const googleIcon = "assets/icons/google.png";
const facebookIcon = "assets/icons/facebook.png";
const instagramIcon = "assets/icons/instagram.png";
const twitterIcon = "assets/icons/twitter.png";
const whatsappIcon = "assets/icons/whatsapp.png";

String? privateKey = "";
String? publicKey = "";
double totalAssetsInUSDT = 0.0;

Future<void> getKeysFromPreferences() async {
  try {
    // Step 1: Retrieve the SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();

    // Step 2: Get the keys from SharedPreferences
    publicKey = prefs.getString('tronAddressRef');
    privateKey = prefs.getString('tronPrivateKeyRef');

    if (publicKey == null || privateKey == null) {
      throw Exception("Keys not found in SharedPreferences.");
    }

    // Step 3: Assign the keys to variables
    print("Public Key from Preferences: $publicKey");
    print("Private Key from Preferences: $privateKey");

    // Step 4: Use the variables (example usage)
    // For demonstration, let's just print them
    print("Using Public Key: $publicKey");
    print("Using Private Key: $privateKey");

    // You can now use `publicKey` and `privateKey` in your app logic
  } catch (e) {
    print("Error retrieving keys from SharedPreferences: $e");
  }
}