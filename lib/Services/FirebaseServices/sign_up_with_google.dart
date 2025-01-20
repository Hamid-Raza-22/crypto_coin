import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';



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

      if (user != null) {
        if (userCredential.additionalUserInfo?.isNewUser ?? false) {
          // User is new, proceed with registration
          Get.offNamed('/login'); // Redirect to the dashboard after successful login
        } else {
          // User already exists, show a snack bar
          Get.snackbar(
            'Error',
            'This email is already registered.',
            snackPosition: SnackPosition.BOTTOM,
          );
          // Optionally sign out the newly signed-in user if desired
          await FirebaseAuth.instance.signOut();
        }
      }
    }
  } catch (e) {
    print('Google Sign-In Error: $e');
  }
}


