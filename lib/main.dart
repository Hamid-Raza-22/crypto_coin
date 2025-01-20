// import 'package:email_otp/email_otp.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Services/FirebaseServices/firebase_options.dart';
import 'Services/FirebaseServices/firebase_remote_config.dart';
import 'Views/AppRoutes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Add this line
  // // Check if Firebase has already been initialized
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await Config.initialize();

    // await FirebaseAppCheck.instance.activate();
    // Enable automatic token refresh
    // await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  }
  // EmailOTP.config(
  //   appName: 'Crypto Coin',
  //   otpType: OTPType.numeric,
  //   emailTheme: EmailTheme.v1,
  // );
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