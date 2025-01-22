import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdrwa_screen.dart';
import 'package:crypto_coin/Views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WithdrawPage extends StatefulWidget {
  @override
  _WithdrawPageState createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  TextEditingController _amountController = TextEditingController();
  double availableBalance = 2760.23;
  String selectedBank = 'monobank'; // Default bank
  List<String> banks = [
    'monobank',
    'bobobank',
    'kolobank',
    'bank1',
    'bank2',
    'bank3',
    'bank4',
    'bank5',
    'bank6',
    'bank7',
    'bank8',
    'bank9',
    'bank10',
  ];

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

    double transactionFee = withdrawalAmount * 0.02;
    double totalWithdrawalAmount = withdrawalAmount + transactionFee;

    if (totalWithdrawalAmount <= availableBalance) {
      Get.to(() => WithdrawScreen(
        withdrawalAmount: withdrawalAmount,
        availableBalance: availableBalance - totalWithdrawalAmount,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Withdraw",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.to(()=> MainScreen());
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // Add additional actions here
            },
          ),
        ],
      ),
      body: Padding(
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
                      // Add deposit functionality
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Deposit",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 10),
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
                    child: Text(
                      "Withdraw",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),

            // You Pay Section
            Center(
              child: Column(
                children: [
                  Text(
                    "You Pay",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  TextField(
                    controller: _amountController,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                    decoration: InputDecoration(
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
            Text(
              "Available Balance",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    availableBalance.toStringAsFixed(2),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "USD",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Withdraw To Section
            Text(
              "Withdraw to",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<String>(
                value: selectedBank,
                isExpanded: true,
                hint: Text("Select Bank"),
                underline: SizedBox(), // Remove underline
                onChanged: (String? newValue) {
                  setState(() {
                    selectedBank = newValue!;
                  });
                },
                items: banks.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Row(
                      children: [
                        Icon(Icons.account_balance, color: Colors.blueAccent),
                        SizedBox(width: 10),
                        Text(bank, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),

            // Numeric Keypad
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 12,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
            SizedBox(height: 20),

            // Withdraw Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmWithdraw,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "WITHDRAW",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
            : Icon(icon, size: 24, color: Colors.grey),
      ),
    );
  }
}
