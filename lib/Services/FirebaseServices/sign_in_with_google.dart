import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import '../../ViewModels/wallet_controlers.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

Future<User?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Sign out from the previous account
  await googleSignIn.signOut();

  // Now initiate the sign-in process
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  if (googleUser == null) {
    // The user canceled the sign-in, show a snackbar
    Get.snackbar(
      'No Account Found',
      'Please select an account to sign in.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return null;
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  final User? user = userCredential.user;

  if (user != null) {
    // Clear existing data in secure storage before saving new data
    await secureStorage.deleteAll();

    final walletCollection = FirebaseFirestore.instance.collection('wallets');
    final walletDoc = await walletCollection.doc(user.email!).get();

    if (walletDoc.exists) {
      Map<String, dynamic>? data = walletDoc.data();
      if (data != null && data.containsKey('tron')) {
        // Retrieve the TRON wallet data
        final tronWallet = data['tron'];
        print("TRON Address: ${tronWallet['address']}");
        print("TRON Private Key: ${tronWallet['privateKey']}");

        // Save the TRON address and private key to secure storage
        await secureStorage.write(key: 'tronAddress', value: tronWallet['address']);
        await secureStorage.write(key: 'tronPrivateKey', value: tronWallet['privateKey']);

        publicKey = await secureStorage.read(key: 'tronAddress');
        privateKey = await secureStorage.read(key: 'tronPrivateKey');

        // Initialize the GetX controller

        // Refresh the controller data from secure storage
        // await walletController.loadTronDataFromSecureStorage();
      } else {
        print("No TRON wallet data found.");
      }
    } else {
      // Show snackbar when no wallet document is found
      Get.snackbar(
        'Wallet Not Found',
        'No wallet document found for this user.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null; // Return null if no wallet document is found
    }
  }
  return user;
}
