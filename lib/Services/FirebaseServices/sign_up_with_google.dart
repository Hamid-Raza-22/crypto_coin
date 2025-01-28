import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../WalletServices/wallet_service.dart';


//
// Future<void> signUpWithGoogle() async {
//   try {
//     final GoogleSignIn googleSignIn = GoogleSignIn();
//     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//
//     if (googleUser != null) {
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );
//
//       final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
//       final User? user = userCredential.user;
//
//       if (user != null) {
//         if (userCredential.additionalUserInfo?.isNewUser ?? false) {
//           // User is new, proceed with registration
//           Get.offNamed('/login'); // Redirect to the dashboard after successful login
//         } else {
//           // User already exists, show a snack bar
//           Get.snackbar(
//             'Error',
//             'This email is already registered.',
//             snackPosition: SnackPosition.BOTTOM,
//           );
//           // Optionally sign out the newly signed-in user if desired
//           await FirebaseAuth.instance.signOut();
//         }
//       }
//     }
//   } catch (e) {
//     print('Google Sign-In Error: $e');
//   }
// }


Future<void> signUpWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Null safety: Ensure user is not null
      if (user == null || user.email == null) {
        throw Exception("User or email is null.");
      }

      // Firestore instance
      final walletCollection = FirebaseFirestore.instance.collection('wallets');
      final walletDoc = await walletCollection.doc(user.email!).get();

      if (walletDoc.exists) {
        // Null safety: Ensure walletDoc data is not null
        final walletData = walletDoc.data();
        if (walletData == null) {
          throw Exception("Wallet data is null.");
        }

        print("Existing Wallet Data: $walletData");

        // Redirect to dashboard or login
        Get.offNamed('/login');
      } else {
        // New user: Generate wallets
        WalletService walletService = WalletService();

        Map<String, String> ethWallet = walletService.generateEthereumWallet();
        Map<String, String> tronWallet = walletService.generateTronWallet();

        // Save wallets to Firebase
        await walletCollection.doc(user.email!).set({
          "email": user.email,
          "ethereum": ethWallet,
          "tron": tronWallet,
        });

        print("Wallets generated and saved successfully!");

        // Redirect to dashboard or login
        Get.offNamed('/login');
      }
    } else {
      throw Exception("Google user is null.");
    }
  } catch (e) {
    print('Google Sign-In Error: $e');
  }
}
