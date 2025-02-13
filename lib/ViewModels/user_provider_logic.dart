// user_provider.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends GetxController {
  // Observable variables to store user data
  var name = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs;
  // Update user data
  setUser() async {
    final prefs = await SharedPreferences.getInstance();


    name.value= prefs.getString('googleName') ?? 'Unknown User';
    email.value  = prefs.getString('googleEmail') ?? '';
    photoUrl.value = prefs.getString('googlePhoto') ?? 'https://via.placeholder.com/150';

  }

  // Clear user data on logout
  void clearUser() {
    name.value = '';
    email.value = '';
    photoUrl.value = '';
    print('User data cleared.');
  }
}