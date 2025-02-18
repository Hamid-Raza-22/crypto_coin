import 'package:crypto_coin/Views/home/WalletComponents/wallet_controller.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_segmented_controlled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wallet_screen_two.dart';
import 'wallet_portfolio_page.dart';

class WalletMainPage extends StatelessWidget {
  final WalletController controller = Get.put(WalletController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

      appBar:  AppBar(
        // backgroundColor: Colors.white,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme
      
        title:
        const Text('Wallet', style: TextStyle(fontWeight: FontWeight.bold)),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back_ios_new),
        //   onPressed: () => Navigator.pop(context),
        // ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.qr_code_scanner),
          //   onPressed: () {},
          // ),
          const SizedBox(width: 16),
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Obx(() => WalletSegmentedControl(
          //   currentIndex: controller.currentIndex.value,
          //   onSegmentChanged: controller.changeIndex,
          // )),
          Expanded(
            child: Obx(() {
              switch (controller.currentIndex.value) {
                case 0:
                  return WalletScreenTwo();
                case 1:
                //  return WalletPortfolioPage();
                default:
                  return WalletScreenTwo();
              }
            }),
          ),
        ],
      ),
    );
  }
}
