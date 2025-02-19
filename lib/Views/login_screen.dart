import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Services/FirebaseServices/sign_in_with_google.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/custom_button.dart';
import '../Components/custom_editable_menu_option.dart';
import '../Components/custom_social_button.dart';
import '../ViewModels/user_provider_logic.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  Future<void> saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }
  Future<void> getKeysFromPreferenceslogin() async {
    try {
      // Step 1: Retrieve the SharedPreferences instance
      final prefs = await SharedPreferences.getInstance();

      // Step 2: Get the keys from SharedPreferences
      publicKey = await prefs.getString('tronAddressRef');
      privateKey = await prefs.getString('tronPrivateKeyRef');

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
  // Future<void> _signInUser() async {
  //   final GoogleSignIn googleSignIn = GoogleSignIn();
  //   final UserProvider userProvider = Get.put(UserProvider());
  //
  //   // Sign out from the previous account
  //   await googleSignIn.signOut();
  //   userProvider.clearUser(); // Clear user data
  //   final email = _emailController.text.trim();
  //   final password = _passwordController.text.trim();
  //
  //   if (email.isEmpty || password.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Please fill in both email and password.')),
  //     );
  //     return;
  //   }
  //
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   int retryCount = 0;
  //   const maxRetries = 3;
  //   const retryDelay = Duration(seconds: 2);
  //
  //   while (retryCount < maxRetries) {
  //     try {
  //       // Firebase Authentication sign-in
  //       final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //       await saveLoginState(true); // Mark user as logged in
  //       await getKeysFromPreferences();
  //       // If successful, navigate to the home screen
  //       Get.offNamed(AppRoutes.homeScreen); // Replace with your home screen route
  //       return;
  //     } on FirebaseAuthException catch (e) {
  //       print('FirebaseAuthException code: ${e.code}');
  //       if (e.code != 'network-request-failed' || retryCount == maxRetries - 1) {
  //         String errorMessage;
  //
  //         switch (e.code) {
  //           case 'invalid-email':
  //             errorMessage = 'The email address is badly formatted.';
  //             break;
  //           case 'user-disabled':
  //             errorMessage = 'This user account has been disabled.';
  //             break;
  //           case 'user-not-found':
  //             errorMessage = 'No user found with this email.';
  //             break;
  //           case 'wrong-password':
  //             errorMessage = 'Incorrect password.';
  //             break;
  //           case 'invalid-credential':
  //             errorMessage = 'The email or password is incorrect.';
  //             break;
  //           case 'network-request-failed':
  //             errorMessage = 'No internet connection. Please check your network and try again.';
  //             break;
  //           case 'too-many-requests':
  //             errorMessage = 'Too many unsuccessful attempts. Please try again later.';
  //             break;
  //           default:
  //             errorMessage = 'An error occurred. Please try again.';
  //         }
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text(errorMessage)),
  //         );
  //         break;
  //       }
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('An unexpected error occurred.')),
  //       );
  //       print('Error: $e');
  //       break;
  //     }
  //
  //     // Wait before retrying
  //     await Future.delayed(retryDelay);
  //     retryCount++;
  //   }
  //
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
_signInUser() async {
  FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final UserProvider userProvider = Get.put(UserProvider());

    // Clear previous user data
    await userProvider.clearUser();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
   SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.setString('isLoggedInEmail', email);
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both email and password.')),
      );
      return;
    }

    setState(() {
      isLoading = true; // Start loading
    });

    int retryCount = 0;
    const maxRetries = 3;
    const retryDelay = Duration(seconds: 2);

    while (retryCount < maxRetries) {
      try {
        // Firebase Authentication sign-in with email and password
        final authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = authResult.user;

        if (user != null) {
          // Save login state
          await saveLoginState(true); // Mark user as logged in

          // Retrieve wallet data from Firestore
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

              // Save a reference to the keys
              await saveKeyReference();

              // Initialize the GetX controller and refresh data
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

            // Reset loading state
            setState(() {
              isLoading = false;
            });
            return; // Exit early if no wallet document is found
          }

          // Navigate to the home screen
          Get.offNamed(AppRoutes.homeScreen); // Replace with your home screen route
          return;
        }
      } on FirebaseAuthException catch (e) {
        print('FirebaseAuthException code: ${e.code}');
        if (e.code != 'network-request-failed' || retryCount == maxRetries - 1) {
          String errorMessage;
          switch (e.code) {
            case 'invalid-email':
              errorMessage = 'The email address is badly formatted.';
              break;
            case 'user-disabled':
              errorMessage = 'This user account has been disabled.';
              break;
            case 'user-not-found':
              errorMessage = 'No user found with this email.';
              break;
            case 'wrong-password':
              errorMessage = 'Incorrect password.';
              break;
            case 'invalid-credential':
              errorMessage = 'The email or password is incorrect.';
              break;
            case 'network-request-failed':
              errorMessage = 'No internet connection. Please check your network and try again.';
              break;
            case 'too-many-requests':
              errorMessage = 'Too many unsuccessful attempts. Please try again later.';
              break;
            default:
              errorMessage = 'An error occurred. Please try again.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );

          // Reset loading state
          setState(() {
            isLoading = false;
          });
          break;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
        print('Error: $e');

        // Reset loading state
        setState(() {
          isLoading = false;
        });
        break;
      }

      // Wait before retrying
      await Future.delayed(retryDelay);
      retryCount++;
    }

    // Ensure loading state is reset after all retries
    setState(() {
      isLoading = false;
    });
  }// Future<void>homepage()async{
//   // Get.offNamed('/HomeScreen'); // Replace with your home screen route
//   Get.offNamed(AppRoutes.homepage); // Replace with your home screen route
//
// }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offNamed(AppRoutes.signup);
        return false; // Prevents the default behavior of closing the app
      },
      child: Scaffold(
        backgroundColor:Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: 'C Coin',
          imageUrl: logo,
          onBackPressed: () => Get.offNamed(AppRoutes.signup),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                 Text(
                  'Login to your Account',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 1.75,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                CustomEditableMenuOption(
                  label: 'Email Address',
                  initialValue: '',
                  onChanged: (value) => _emailController.text = value,
                  icon: Icons.mail_outline_rounded,
                  iconColor: Colors.blueAccent,
                  borderColor: Colors.blueAccent,
                ),
                const SizedBox(height: 10),
                CustomEditableMenuOption(
                  label: 'Password',
                  initialValue: '',
                  onChanged: (value) => _passwordController.text = value,
                  icon: Icons.lock_outline_rounded,
                  iconColor: Colors.blueAccent,
                  borderColor: Colors.blueAccent,
                  obscureText: true,
                ),
                const SizedBox(height: 2),
                CustomEditableMenuOption(
                  label: 'Reference Code',
                  initialValue: '',
                  onChanged: (value) => _passwordController.text = value,
                  icon: Icons.lock_outline_rounded,
                  iconColor: Colors.blueAccent,
                  borderColor: Colors.blueAccent,
                  obscureText: false,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 0.1),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      final String email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        try {
                          // Send password reset email
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

                          // Show success message
                          Get.snackbar(
                            'Success',
                            'Password reset email sent to $email. Please check your inbox.',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } catch (e) {
                          // Handle errors
                          Get.snackbar(
                            'Error',
                            'Failed to send password reset email: ${e.toString()}',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                        }
                      } else {
                        Get.snackbar(
                          'Error',
                          'Please enter your email address.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                      },
                    child: const Text(
                      'Forgot your password?',
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        height: 1.6,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                CustomButton(
                  borderRadius: 10,
                  buttonText: isLoading ? 'Please wait...':'Sign in',
                  gradientColors: const [Colors.blueAccent, Colors.blueAccent],
                  onTap: isLoading
                    ? null  // Disable onTap when loading
                    : () async {
                    User? user = await _signInUser();
                    if( user != null){
                      //Get.offNamed(AppRoutes.accountActivationScreen);
                      await saveLoginState(true); // Mark user as logged in
                      await getKeysFromPreferenceslogin();
                      Get.offNamed(AppRoutes.homeScreen);
                    }else{

                    }
                  } ,
                  // onTap: _signInUser,
                ),
                const SizedBox(height: 40),
                Text(
                  '----------- or continue with -----------',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    height: 1.6,
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                _buildSocialButtons(context),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSocialButton(
          icon: FontAwesomeIcons.facebookF,
          color: Colors.blue,
          onTap: () => Get.offNamed('/reportIssues'),
        ),
        _buildSocialButton(
          iconImage: AssetImage(googleIcon),
            color: Colors.black,
          onTap: () async {
            User? user = await signInWithGoogle();
            if( user != null){
              //Get.offNamed(AppRoutes.accountActivationScreen);
              await saveLoginState(true); // Mark user as logged in
              await getKeysFromPreferences();
              Get.offNamed(AppRoutes.homeScreen);
            }else{

            }
          } ,
        ),
        // _buildSocialButton(
        //   icon: FontAwesomeIcons.apple,
        //     color: Colors.black,
        //   onTap: () => Get.offNamed('/reportIssues'),
        // ),
      ],
    );
  }

  Widget _buildSocialButton({
    IconData? icon,
    AssetImage? iconImage,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SocialButton(
      icon: icon,
      iconImage: iconImage,
      color: color,
      onTap: onTap,
    );
  }
}
