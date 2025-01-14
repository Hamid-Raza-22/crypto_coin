import 'package:crypto_coin/Views/main_screen.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Services/FirebaseServices/firebase_options.dart';
import 'Views/AppRoutes/app_routes.dart';
import 'Views/confirm_email_screen.dart';
import 'Views/create_password_screen.dart';
import 'Views/email_code_screen.dart';
import 'Views/login_screen.dart';
import 'Views/singup_screen.dart';
import 'Views/splesh_screen.dart';
import 'Views/step_one_email_screen.dart';
import 'Views/successfully_create_accont.dart';
import 'Views/three_step_lock_screen.dart';
import 'Views/verification_success_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Add this line
  // // Check if Firebase has already been initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebaseAppCheck.instance.activate();
    // Enable automatic token refresh
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
   }
  EmailOTP.config(
    appName: 'Crypto Coin',
    otpType: OTPType.numeric,
    emailTheme: EmailTheme.v1,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.routes,
    );
  }
}
