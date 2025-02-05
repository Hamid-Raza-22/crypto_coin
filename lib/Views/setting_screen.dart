// settings_page.dart
import 'package:crypto_coin/Views/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = false;


final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

void logout() async {
  // Clear user session data from SharedPreferences
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.clear(); // This will clear all stored preferences
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Sign out from the previous account
  await googleSignIn.signOut();
  // Clear user session data from Secure Storage
  await secureStorage.deleteAll(); // This will clear all stored secure data

  // If you have any global variables, reset them here
  // Example: Global.user = null;

  // Navigate to the login screen
  Navigator.of(context).pushReplacementNamed('/login');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Search functionality can be implemented here
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // User Profile Section
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            title: Text('Demo User'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('demo@example.com'),
                Text(
                  'ID 289497641',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Colors.green),
              ],
            ),
          ),
          SizedBox(height: 16),
          Divider(),

          // Privacy Section
          buildSectionTitle('Privacy'),
          buildListTile(Icons.person, 'Profile', () {    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage()),
          );}),
          buildListTile(Icons.lock, 'Security', () {}),

          Divider(),

          // Finance Section
          buildSectionTitle('Finance'),
          buildListTile(Icons.history, 'History', () {}),
          buildListTile(Icons.production_quantity_limits, 'Limits', () {}),

          Divider(),

          // Account Section
          buildSectionTitle('Account'),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Theme'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(isDarkMode ? 'Dark mode' : 'Light mode'),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                      // Update theme mode in your app
                      // Use a ThemeProvider or equivalent
                    });
                  },
                ),
              ],
            ),
          ),
          buildListTile(Icons.notifications, 'Notifications', () {}),

          Divider(),

          // More Section
          buildSectionTitle('More'),
          buildListTile(Icons.card_giftcard, 'My bonus', () {}),
          buildListTile(Icons.share, 'Share with friends', () {}),
          buildListTile(Icons.support, 'Support', () {}),

          Divider(),

          // Logout Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.all(16),
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(fontSize: 16),
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
        style: TextStyle(
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
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
