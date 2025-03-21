// import 'package:email_otp/email_otp.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'Services/FirebaseServices/firebase_options.dart';
import 'Services/FirebaseServices/firebase_remote_config.dart';
import 'ViewModels/theme_provider.dart';
import 'ViewModels/user_provider_logic.dart';
import 'Views/AppRoutes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
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
  //   appName: 'C Coin',
  //   otpType: OTPType.numeric,
  //   emailTheme: EmailTheme.v1,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(ThemeController()); // Initialize ThemeController
        Get.put(UserProvider()); // Initialize UserProvider
      }),
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
        // colorScheme: ColorScheme.light(
        //   primary: Colors.blue, // Primary color
        //   secondary: Colors.green, // Secondary color
        //   background: Colors.white, // Background color
        //   surface: Colors.white, // Surface color (e.g., cards, dialogs)
        //   onBackground: Colors.black, // Text color on background
        //   onSurface: Colors.black, // Text color on surface
        // ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black, // Custom text color for light mode
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black
          ),
          bodyMedium: TextStyle(
            color: Colors.white, // Custom text color for dark mode
          ),
        ),
      ),
      themeMode: themeController.themeMode.value, // Use ThemeController's themeMode
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.routes,
    ));
  }
}