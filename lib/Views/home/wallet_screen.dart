import 'package:crypto_coin/Views/home/widgets/custom_appbar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';
import '../exchange/exchange_page.dart';
import '../fade_route.dart';

part 'widgets/mastercard_widget.dart';

part 'widgets/top_bar.dart';

part 'widgets/rates.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 32.0;
    return const Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: 'Crypto Coin',
        imageUrl: 'assets/images/logo.png',
        // onBackPressed: () => Get.offNamed('/ThreeStepLockScreen'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: spacing),
          // TopBar(
          //   margin: EdgeInsets.symmetric(
          //     horizontal: spacing,
          //   ),
          // ),
          //SizedBox(height: spacing),
          MastercardWidget(
            margin: EdgeInsets.symmetric(
              horizontal: spacing,
            ),
          ),
          // SizedBox(height: spacing),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: Text(
              "\"App under Construction\"",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: spacing),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: Text(
              "Today's Rates",
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black),
            ),
          ),
          Expanded(
            child: RatesList(
              spacing: spacing,
            ),
          ),
        ],
      ),
    );
  }
}