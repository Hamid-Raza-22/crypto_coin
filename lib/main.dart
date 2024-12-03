import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Views/login_screen.dart';
import 'Views/singup_screen.dart';
import 'Views/splesh_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Add this line
  // // Check if Firebase has already been initialized
  // if (Firebase.apps.isEmpty) {
  //   await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  // }
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
        // GetPage(name: '/transactionHistory', page: () => TransactionHistory()),
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
