import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ViewModels/user_provider_logic.dart';
import '../../ViewModels/wallet_controlers.dart';

const FlutterSecureStorage secureStorage = FlutterSecureStorage();
Future<void> saveKeyReference() async {
  try {
    // Step 1: Retrieve the keys from secure storage
    String? publicKey = await secureStorage.read(key: 'tronAddress');
    String? privateKey = await secureStorage.read(key: 'tronPrivateKey');

    if (publicKey == null || privateKey == null) {
      throw Exception("Keys not found in secure storage.");
    }

    // Step 2: Save a reference to these keys (e.g., in shared preferences or another storage)
    // For example, using SharedPreferences to save a reference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tronAddressRef', publicKey);
    await prefs.setString('tronPrivateKeyRef', privateKey);

    print("Key references saved successfully.");
  } catch (e) {
    print("Error saving key references: $e");
  }
}
Future<User?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final UserProvider userProvider = Get.put(UserProvider());

  // Sign out from the previous account
  await googleSignIn.signOut();
  userProvider.clearUser(); // Clear user data

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
// Debugging: Print Google Sign-In data
  print('Google User Name: ${googleUser.displayName}');
  print('Google User Email: ${googleUser.email}');
  print('Google User Photo URL: ${googleUser.photoUrl}');
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
  final User? user = userCredential.user;

  if (user != null) {
    // Retrieve user details
    final String userName = googleUser.displayName ?? 'Unknown User';
    final String userEmail = googleUser.email;
    final String userPhotoUrl = googleUser.photoUrl ?? 'https://via.placeholder.com/150';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('googleName', userName);
    await prefs.setString('googleEmail', userEmail);
    await prefs.setString('googlePhoto', userPhotoUrl);
    // Store user data in the provider
    await userProvider.setUser();
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

        await saveKeyReference(); // Save a reference to the keys

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
