import 'package:crypto_coin/Views/home/WalletComponents/wallet_main_page.dart';
import 'package:crypto_coin/Views/setting_screen.dart';
import 'package:flutter/material.dart';
// import 'package:crypto_coin/Views/home/wallet_screen.dart';

import 'home/channel_screen.dart';
import 'home/home_screen.dart';
import 'home/service_screen.dart';
import 'home/team_screen.dart';
import 'home/WalletComponents/wallet_screen_two.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    HomeScreen(),
    TeamScreen(),
    ChannelScreen(),
     WalletMainPage(),
    SettingsPage(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz_sharp),
            label: 'Service',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Team',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedIconTheme: const IconThemeData(size: 28),
      ),
    );
  }
}
