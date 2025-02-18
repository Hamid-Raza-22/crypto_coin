// user_provider.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/global_variables.dart';

class UserProvider extends GetxController {
  // Observable variables to store user data
  var name = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs;
  // Update user data
  setUser() async {
    final prefs = await SharedPreferences.getInstance();


    name.value= prefs.getString('googleName') ?? 'C Coin User';
    email.value  = (prefs.getString('googleEmail') ?? prefs.getString("isLoggedInEmail"))??"User Email";
    photoUrl.value = prefs.getString('googlePhoto')?? logo;

  }

clearUser() {
    name.value = '';
    email.value = '';
    photoUrl.value = '';
    print('User data cleared.');
  }
}