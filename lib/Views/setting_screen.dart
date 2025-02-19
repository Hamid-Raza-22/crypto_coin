// settings_page.dart
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/edit_profile_screen.dart';
import 'package:crypto_coin/Views/home/channel_screen.dart';
import 'package:crypto_coin/Views/limit_policy_page.dart';
import 'package:crypto_coin/Views/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/FirebaseServices/sign_in_with_google.dart';
import '../ViewModels/theme_provider.dart';
import '../ViewModels/user_provider_logic.dart';
import 'package:share_plus/share_plus.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;
  final themeController = Get.put(ThemeController());
   final UserProvider userProvider = Get.put(UserProvider());

  Future<void> saveLoginState(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }

  void logout() async {
    try {
      // Mark user as logged out
      saveLoginState(false);

      // Clear user session data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear(); // This will clear all stored preferences

      // Reset the dialog state
      await prefs.setBool('isDialogShown', false); // Reset dialog state to false

      final GoogleSignIn googleSignIn = GoogleSignIn();
      // Sign out from the previous account
      await googleSignIn.signOut();

      // Clear user session data from Secure Storage
      await secureStorage.deleteAll(); // This will clear all stored secure data

      final UserProvider userProvider = Get.put(UserProvider());
      userProvider.clearUser(); // Clear user data

      // Clear private and public keys
      privateKey = ""; // or privateKey.clear() if it's a List/Map
      publicKey = "";  // or publicKey.clear() if it's a List/Map

      // Clear any other user-related data you have stored
      // If you have any global variables, reset them here
      // Example: Global.user = null;

      // Navigate to the login screen
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print("Error during logout: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
   userProvider.setUser();
    print('Name: ${userProvider.name.value}');
    print('Email: ${userProvider.email.value}');
    print('Photo URL: ${userProvider.photoUrl.value}');
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme


      appBar: AppBar(
        // backgroundColor: Colors.white,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Search functionality can be implemented here
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // User Profile Section
          Obx(() => ListTile(
            contentPadding: EdgeInsets.zero,

              leading: CircleAvatar(
                backgroundImage:
                     AssetImage(userProvider.photoUrl.value),
              ),
            title: Text(userProvider.name.value),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userProvider.email.value,),
               Text(
                  "ID: $publicKey", // Replace with actual user ID if available
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Colors.green),
              ],
            ),
          )),
          //const SizedBox(height: 16),
          const Divider(),

          // Privacy Section
          buildSectionTitle('Privacy'),
          // buildListTile(Icons.person, 'Profile', () {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => EditProfilePage()),
          //   );
          // }),
          buildListTile(Icons.privacy_tip, 'Privacy', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
            );
          }),
          // buildListTile(Icons.lock, 'Security', () {}),

          const Divider(),

          // Finance Section
          // buildSectionTitle('Finance'),
         // buildListTile(Icons.history, 'History', () {}),
          buildListTile(Icons.production_quantity_limits, 'Limits', () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => LimitsPolicyPage()),
    );

          }),

          const Divider(),

          // Account Section
          buildSectionTitle('Account'),
          Column(
            children: [
              Obx(() {
                final themeController = Get.find<ThemeController>();
                return ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('Theme'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(themeController.themeMode.value == ThemeMode.dark
                          ? 'Dark Mode'
                          : 'Light Mode'),
                      Switch(
                        value: themeController.themeMode.value == ThemeMode.dark,
                        onChanged: (value) {
                          themeController.toggleTheme(); // Toggle Theme
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
         // buildListTile(Icons.notifications, 'Notifications', () {}),

          const Divider(),

          // More Section
          buildSectionTitle('More'),
          // buildListTile(Icons.card_giftcard, 'My bonus', () {}),
         buildListTile(Icons.share, 'Share with friends', () {
           Share.share('Check out this awesome C Coin app! https://adminportal.cryptocoinworld.net/CCoinv0.1.6.apk');
         }),

          buildListTile(Icons.support, 'Support', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChannelScreen()),
            );
          }),

          const Divider(),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,

                  padding: const EdgeInsets.all(16),
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
