import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  // Default theme mode
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    loadTheme(); // Load saved theme when the controller is initialized
  }

  // Load saved theme from SharedPreferences
  void loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('themeMode') ?? 'light';
    themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  // Toggle between light and dark themes
  void toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
      prefs.setString('themeMode', 'dark'); // Save theme preference
    } else {
      themeMode.value = ThemeMode.light;
      prefs.setString('themeMode', 'light'); // Save theme preference
    }
  }
}