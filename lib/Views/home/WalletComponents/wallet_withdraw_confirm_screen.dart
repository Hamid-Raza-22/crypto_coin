import 'package:crypto_coin/Views/home/WalletComponents/wallet_deposit_screen.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdrwa_screen.dart';
import 'package:crypto_coin/Views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utilities/global_variables.dart';

class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TextEditingController _amountController = TextEditingController();
  //double availableBalance =  33.66;
  double availableBalance =  totalAssetsInUSDT;

  String selectedBank = 'Enter Public Address'; // Default bank

  void _updateAmount(String value) {
    setState(() {
      _amountController.text = _amountController.text + value;
    });
  }

  void _backspace() {
    setState(() {
      if (_amountController.text.isNotEmpty) {
        _amountController.text = _amountController.text
            .substring(0, _amountController.text.length - 1);
      }
    });
  }



  void _confirmWithdraw() {
    double withdrawalAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (withdrawalAmount <= 0) {
      // Notify user to enter a valid amount
      Get.snackbar(
        'Invalid Amount',
        'Please enter an amount greater than zero.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }
    if (publicAddressController.text.isEmpty) {
      // Notify user to enter a valid amount
      Get.snackbar(
        'Enter Tron Address',
        'Please enter an valid Address.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    double transactionFee = withdrawalAmount * 0.02;
    double totalWithdrawalAmount = withdrawalAmount + transactionFee;

    if (totalWithdrawalAmount <= availableBalance) {
      Get.to(
        () => WithdrawScreen(
          withdrawalAmount: withdrawalAmount,
          availableBalance: availableBalance - totalWithdrawalAmount,
          publicKeyAddress: publicAddressController.text,

        ),
      );
    } else {
      // Display snackbar about insufficient balance
      Get.snackbar(
        'Insufficient Balance',
        'Please enter an amount less than your available balance.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  final TextEditingController  publicAddressController = TextEditingController();
  String? enteredValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text(
            "Withdraw",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.to(() => MainScreen());
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {
                // Add additional actions here
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Toggle Between Deposit and Withdraw
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const WalletDepositScreen()),
                          );
                          // Add deposit functionality
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Deposit",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Add withdraw functionality
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Withdraw",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // You Pay Section
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "You Pay",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextField(
                        controller: _amountController,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "\$0",
                        ),
                        textAlign: TextAlign.center,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                // Available Balance Section
                const Text(
                  "Available Balance",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        availableBalance.toStringAsFixed(1),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "USD",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // Withdraw To Section
                const Text(
                  "Withdraw to Trc20",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: // TextField for user input
                      // TextField for user input
                      TextField(
                    controller:  publicAddressController,
                    decoration: const InputDecoration(
                      hintText: "Enter Tron Address",
                      border: InputBorder.none, // Remove all borders (including underline)
                    ),
                  ),
                ),

                const SizedBox(height:5),
                // Withdraw To Section
                const Text(
                  "Tron: TKSRbKd1K8v62F*****Md19joP1oxCPTjP",
                  style: TextStyle(fontSize: 12),
                ),


                const SizedBox(height: 20),

                // Numeric Keypad
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 12,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return Container();
                    } else if (index == 10) {
                      return KeypadButton(
                        text: "0",
                        onTap: () {
                          _updateAmount("0");
                        },
                      );
                    } else if (index == 11) {
                      return KeypadButton(
                        icon: Icons.backspace,
                        onTap: () {
                          _backspace();
                        },
                      );
                    } else {
                      return KeypadButton(
                        text: "${index + 1}",
                        onTap: () {
                          _updateAmount("${index + 1}");
                        },
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Withdraw Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmWithdraw,
                    //onPressed: main,
                   // onPressed: main,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "WITHDRAW",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }
}

class KeypadButton extends StatelessWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onTap;

  KeypadButton({this.text, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: text != null
            ? Text(
                text!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : Icon(icon, size: 24, color: Colors.grey),
      ),
    );
  }
}
