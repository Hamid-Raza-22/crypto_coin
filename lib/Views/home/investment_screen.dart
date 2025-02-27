import 'package:crypto_coin/Components/custom_appbar.dart';
import 'package:crypto_coin/Views/home/investment_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../Components/custom_button.dart';
import '../../Components/custom_editable_menu_option.dart';
import '../../Utilities/global_variables.dart';
import '../AppRoutes/app_routes.dart';
import '../main_screen.dart';
import 'WalletComponents/wallet_deposit_screen.dart';
import 'WalletComponents/wallet_withdraw_confirm_screen.dart';
import 'investments_deposit_screen.dart';
import 'investments_withdraw_screen.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({Key? key}) : super(key: key);

  @override
  _InvestmentScreenState createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen> {
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // _buildActionButton(Icons.add, 'Deposit', ()=>Get.to(WalletDepositScreen())),
        _buildActionButton(Icons.add, 'Deposit', ()=>Get.to(() =>  InvestmentsDepositScreen())),
        _buildActionButton(FontAwesomeIcons.dollarSign, 'Withdraw',()=>Get.to(() => InvestmentsWithdrawScreen())),
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
          gradientColors: const [Colors.red, Colors.red],
          onTap: onTap,
          borderRadius: 100.0,
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          "INVESTMENTS",
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.to(() => MainScreen());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Add history action here
                 Get.to(() =>  InvestmentHistoryScreen());
            },
          ),
        ],
      ),

        body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildActionButtons(),
              const SizedBox(height: 10),

              Container(
                color: Colors.red,
                height: 20,
                width: double.infinity,
              ),
              const SizedBox(height: 10),

              // Investment Section
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('INVESTMENT',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$100'),
                ],
              ),
              const Divider(color: Colors.red, thickness: 1),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PROFIT PER DAY',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$1'),
                ],
              ),
              const Divider(color: Colors.red, thickness: 1),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SERVICES CHARGE',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('2%'),
                ],
              ),

              const SizedBox(height: 10), // Reduced space

              // Plan Highlights Section
              Center(
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    'PLAN HIGHLIGHTS',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('MINIMUM INVESTMENT',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$100 - \$1000'),
                ],
              ),
              const Divider(color: Colors.red, thickness: 1),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PROFIT PER DAY',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$1 - \$10'),
                ],
              ),
              const Divider(color: Colors.red, thickness: 1),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('PROFIT CALCULATION',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('1%'),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'ESTIMATED PROFIT \$1 PER DAY (2% SERVICES COMMISSION).\nANNUAL PROFIT POTENTIAL',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10), // Reduced space

              // Dollar Section
              Center(
                child: Container(
                  color: Colors.red,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    'DOLLAR',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('MONTHLY', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$30-300'),
                ],
              ),
              const Divider(color: Colors.red, thickness: 1),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('YEARLY', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$365-3650'),
                ],
              ),

              const SizedBox(height: 10), // Reduced space

              // Risk Management
           Text(
                'RISK MANAGEMENT: UP TO 20% RISK PER TRADE.\n100% Non-refundable DEDUCTION APPLIES',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
