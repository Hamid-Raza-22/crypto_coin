import 'package:crypto_coin/Views/home/WalletComponents/wallet_deposit_screen.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdrwa_screen.dart';
import 'package:crypto_coin/Views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Utilities/global_variables.dart';

class InvestmentsDepositScreen extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<InvestmentsDepositScreen> {
  TextEditingController _amountController = TextEditingController();
  double availableBalance = totalAssetsInUSDT;
  String selectedBank = 'Enter Public Address'; // Default bank
  double withdrawalAmount = 0.0; // Add this line

  void _updateAmount(String value) {
    setState(() {
      _amountController.text = _amountController.text + value;
      withdrawalAmount = double.tryParse(_amountController.text) ?? 0.0; // Update withdrawalAmount here
    });
  }

  void _backspace() {
    setState(() {
      if (_amountController.text.isNotEmpty) {
        _amountController.text = _amountController.text.substring(0, _amountController.text.length - 1);
        withdrawalAmount = double.tryParse(_amountController.text) ?? 0.0; // Update withdrawalAmount here
      }
    });
  }

  void _confirmWithdraw() {
    withdrawalAmount = double.tryParse(_amountController.text) ?? 0.0; // Reuse the class-level variable

    if (withdrawalAmount < 100) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter an amount greater than or equal to 100.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (withdrawalAmount <= 0) {
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
      Get.snackbar(
        'Enter Tron Address',
        'Please enter a valid Address.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return;
    }

    double transactionFee = withdrawalAmount * 0.02;
    double totalWithdrawalAmount = withdrawalAmount + transactionFee;

    if (totalWithdrawalAmount <= availableBalance) {
      // Get.to(
      //       () => WithdrawScreen(
      //     withdrawalAmount: withdrawalAmount,
      //     availableBalance: availableBalance - totalWithdrawalAmount,
      //     publicKeyAddress: publicAddressController.text,
      //   ),
      // );
    } else {
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Text(
            "Deposit",

          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.to(() => MainScreen());
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
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
                // Toggle Between Deposit and Deposit
                // Row(
                //   children: [
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) =>
                //                 const WalletDepositScreen()),
                //           );
                //           // Add deposit functionality
                //         },
                //         style: TextButton.styleFrom(
                //           backgroundColor: Colors.grey[200],
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //         ),
                //         child: const Text(
                //           "Deposit",
                //           style: TextStyle(color: Colors.black),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     Expanded(
                //       child: TextButton(
                //         onPressed: () {
                //           // Add withdraw functionality
                //         },
                //         style: TextButton.styleFrom(
                //           backgroundColor: Colors.blueAccent,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(8),
                //           ),
                //         ),
                //         child: const Text(
                //           "Deposit",
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 5),

                // You Pay Section
                Center(
                  child: Column(
                    children: [
                      const Text(
                        "Amount must be greater than 100",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      TextField(
                        controller: _amountController,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "\$100",
                          hintStyle: TextStyle(
                            fontSize: 32, // Chhota font size
                            fontWeight: FontWeight.normal, // Normal font weight
                            color: Colors.grey.withOpacity(0.8), // Halka grey color
                          ),
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

                // Deposit To Section
                const Text(
                 // "Deposit to Trc20",
                  "Deposit",
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
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                    controller:  publicAddressController,
                    decoration: const InputDecoration(
                      hintText: "Enter Tron Address",

                      border: InputBorder.none, // Remove all borders (including underline)
                    ),
                  ),
                ),

                const SizedBox(height:5),
                // Deposit To Section
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

                // Deposit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmWithdraw,
                    //onPressed: main,
                    // onPressed: main,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "DEPOSIT",
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
          color: Colors.grey.shade300,
          // color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: text != null
            ? Text(
          text!,
          style:
          TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color),
        )
            : Icon(icon, size: 24, color:Theme.of(context).textTheme.titleLarge?.color),
      ),
    );
  }
}
