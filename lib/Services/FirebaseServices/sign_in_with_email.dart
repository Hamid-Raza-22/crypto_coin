// Future<void> _signUpWithEmail() async {
//   try {
//     await _auth.createUserWithEmailAndPassword(
//       email: _emailController.text.trim(),
//       password: _passwordController.text.trim(),
//     );
//     // Save user data to Firestore
//     await FirebaseFirestore.instance.collection('UserWithEmailAndPassword').doc(_emailController.text).set({
//       // 'town_name': _nameController.text,
//       // 'town_address': _addressController.text,
//       // 'owner_name': _ownerController.text,
//       'email': _emailController.text,
//       'password': _passwordController.text,
//       // 'image': imageUrl,
//       // 'phone': _contactNumberController.text, // Storing phone number
//     });
//
//     Get.snackbar(" Login Successful", "", backgroundColor: Colors.green, snackPosition: SnackPosition.BOTTOM);
//     Get.offNamed('/login');
//   } catch (e) {
//     Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
//   }
// }

