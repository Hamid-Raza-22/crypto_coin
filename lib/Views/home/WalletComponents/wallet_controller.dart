import 'package:crypto_coin/Views/home/WalletComponents/wallet_portfolio_page.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_screen_two.dart';
import 'package:get/get.dart';

// class WalletController extends GetxController {
//   var currentIndex = 0.obs;
//
//   void changeIndex(int index) {
//     currentIndex.value = index;
//     if (index == 0) {
//       Get.to(WalletScreenTwo());
//     } else if (index == 1) {
//       Get.to(WalletPortfolioPage());
//     }
//   }
// }
// import 'package:get/get.dart';

class WalletController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
