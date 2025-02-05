// import 'package:get/get.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// class WalletController extends GetxController {
//   var tronAddress = ''.obs;
//   var tronPrivateKey = ''.obs;
//
//   final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadTronDataFromSecureStorage();
//   }
//
//   loadTronDataFromSecureStorage() async {
//     String? address = await secureStorage.read(key: 'tronAddress');
//     String? privateKey = await secureStorage.read(key: 'tronPrivateKey');
//
//     if (address != null && privateKey != null) {
//       tronAddress.value = address;
//       tronPrivateKey.value = privateKey;
//     }
//   }
//
//   void setTronData(String address, String privateKey) async {
//     await secureStorage.write(key: 'tronAddress', value: address);
//     await secureStorage.write(key: 'tronPrivateKey', value: privateKey);
//     tronAddress.value = address;
//     tronPrivateKey.value = privateKey;
//   }
// }
