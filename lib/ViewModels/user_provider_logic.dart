// user_provider.dart
import 'package:get/get.dart';

class UserProvider extends GetxController {
  // Observable variables to store user data
  var name = ''.obs;
  var email = ''.obs;
  var photoUrl = ''.obs;

  // Update user data
  setUser(String userName, String userEmail, String userPhotoUrl) {
    name.value = userName;
    email.value = userEmail;
    photoUrl.value = userPhotoUrl;
    print('User data updated: $userName, $userEmail, $userPhotoUrl');
  }

  // Clear user data on logout
  void clearUser() {
    name.value = '';
    email.value = '';
    photoUrl.value = '';
    print('User data cleared.');
  }
}