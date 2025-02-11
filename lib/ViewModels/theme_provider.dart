import 'package:flutter/material.dart';
import 'package:get/get.dart';


  class ThemeController extends GetxController {
    // Default theme mode
    Rx<ThemeMode> themeMode = ThemeMode.light.obs;

    // Toggle between light and dark themes
    void toggleTheme() {
      if (themeMode.value == ThemeMode.light) {
        themeMode.value = ThemeMode.dark;
      } else {
        themeMode.value = ThemeMode.light;
      }
    }
  }
