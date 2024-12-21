import 'package:crypto_coin/Views/home_screen.dart';
import 'package:email_otp/email_otp.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Services/FirebaseServices/firebase_options.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green, // Set primary color to green
      ),      //initialRoute: isAuthenticated ? '/home' : '/login',
      initialRoute: '/splashScreen',
      getPages: [
        GetPage(name: '/splashScreen', page: () => const SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        // GetPage(name: '/adminPanel', page: () => const AdminPanel()),
        // GetPage(name: '/getStarted', page: () =>  const GetStartedPage()),
        GetPage(name: '/signup', page: () =>  SignupScreen()),
        GetPage(name: '/ThreeStepLockScreen', page: () =>  ThreeStepLockScreen()),
        GetPage(name: '/StepOneEmailScreen', page: () =>  StepOneEmailScreen()),
        GetPage(name: '/ConfirmEmailScreen', page: () =>  ConfirmEmailScreen()),
        GetPage(name: '/EmailCodeScreen', page: () =>  EmailCodeScreen()),
        GetPage(name: '/VerificationSuccessScreen', page: () =>  VerificationSuccessScreen()),
        GetPage(name: '/CreatePasswordScreen', page: () =>  CreatePasswordScreen()),
        GetPage(name: '/SuccessfullyCreateAccount', page: () =>  SuccessfullyCreateAccount()),
        GetPage(name: '/HomeScreen', page: () => HomeScreen()),
        // GetPage(name: '/rideHistory', page: () => RideHistory()),
        // GetPage(name: '/accountSetting', page: () => AccountSetting()),
        // GetPage(name: '/home', page: () => HomeScreen()),
        // GetPage(name: '/scooters', page: () => ScootersScreen()),
        // GetPage(name: '/GTSLscooters', page: () => GTSLScootersScreen()),
        // GetPage(name: '/QrScreen', page: () => QrScreen()),
        // GetPage(name: '/viewProfile', page: () => ViewProfile()),
        // GetPage(name: '/editProfile', page: () => EditProfile()),
        // GetPage(name: '/reportIssues', page: () => ReportIssues()),
        // GetPage(name: '/submitReportIssues', page: () => SubmitReportIssue()),
        // GetPage(name: '/paymentMethods', page: () => PaymentMethods()),
        // GetPage(name: '/help', page: () => Help()),
        // GetPage(name: '/contactUS', page: () => ContactUs()),
        // GetPage(name: '/myTickets', page: () => MyTickets()),

      ],
    );
  }
}
