import 'package:crypto_coin/Views/home/WalletComponents/wallet_controller.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_deposit_screen.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdraw_confirm_screen.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdrwa_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../Components/custom_button.dart';
import '../../../Components/custom_editable_menu_option.dart';
import '../../../Utilities/global_variables.dart';

class WalletScreenTwo extends StatelessWidget {
  final WalletController controller = Get.put(WalletController());

   WalletScreenTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: _buildAppBar(),
      body: SingleChildScrollView(
         padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SizedBox(height: 10),
            // _buildBalanceRow(context),
            const SizedBox(height: 16),
            _buildCardWidget(context),
            const SizedBox(height: 20),
            _buildActionButtons(),
            const SizedBox(height: 10),
            _buildSectionTitle('Transaction History'),
            _buildTransactionList(context),
          ],
        ),
      ),
    );
  }
  //
  // AppBar _buildAppBar() {
  //   return AppBar(
  //     backgroundColor: Colors.white,
  //     elevation: 0,
  //     leading: IconButton(
  //       icon: Icon(Icons.arrow_back_ios, color: Colors.black),
  //       onPressed: () {},
  //     ),
  //     title: Text('Wallet',
  //         style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
  //     centerTitle: true,
  //     actions: [
  //       IconButton(
  //         icon: Icon(Icons.qr_code_scanner, color: Colors.black),
  //         onPressed: () {},
  //       ),
  //     ],
  //   );
  // }
  //


  // Widget _buildBalanceRow(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Row(
  //         children: [
  //           Text('My Balance: ',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
  //           Text('\$${totalAssetsInUSDT.toStringAsFixed(2)}',
  //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //         ],
  //       ),
  //       IconButton(
  //         icon: Icon(Icons.visibility, color: Colors.black),
  //         onPressed: () {},
  //       ),
  //     ],
  //   );
  // }

  Widget _buildCardWidget(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 6, offset: Offset(0, 2)),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            _buildCardHeader(),
            _buildCardNumber(),
            _buildCardFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Crypto Balance',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        Icon(Icons.wifi, color: Colors.white),
      ],
    );
  }

  Widget _buildCardNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
      '\$${totalAssetsInUSDT.toStringAsFixed(2)}',
        style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0),
      ),
    );
  }

  Widget _buildCardFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCardDetail('Card Holder', 'Marcus Aurelius'),
        _buildCardDetail('Expire', '03/29'),
      ],
    );
  }

  Widget _buildCardDetail(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // _buildActionButton(Icons.add, 'Deposit', ()=>Get.to(WalletDepositScreen())),
        _buildActionButton(Icons.add, 'Deposit', ()=>Get.to(() => const WalletDepositScreen())),
        _buildActionButton(FontAwesomeIcons.dollarSign, 'Withdraw',()=>Get.to(() => WithdrawPage())),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label,VoidCallback? onTap) {
    return Column(
      children: [
        CustomButton(
          width: 50,
          height: 50,
          // spacing: 0,
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          icon: icon,
          iconPosition: IconPosition.right,
          iconColor: Colors.white,
          iconSize: 20,
          // buttonText: 'Join Channel',
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontFamily: 'Readex Pro',
            fontWeight: FontWeight.bold,
          ),
          gradientColors: const [Colors.blueAccent, Colors.blueAccent],
           onTap: onTap,
          borderRadius: 100.0,
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Center(
        child: Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        _buildTransactionTile('Apple', 'Payment for subscription', '-\$8.99', FontAwesomeIcons.iceCream),
        _buildTransactionTile(
            'Netflix', 'Payment for subscription', '-\$12.99', FontAwesomeIcons.f),
        _buildTransactionTile('Deposit', 'Cryptocurrency', '+\$2000.00', FontAwesomeIcons.faceAngry),
      ],
    );
  }

  Widget _buildTransactionTile(String title, String subtitle, String amount, IconData icons) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade200,
        child: const Icon(Icons.account_balance_wallet, color: Colors.grey),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle:
          Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      trailing: Text(
        amount,
        style: TextStyle(
          color: amount.startsWith('+') ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
