import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_transaction_success.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdraw_confirm_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../Services/WalletServices/tron_services.dart';

class WithdrawScreen extends StatelessWidget {
  final double withdrawalAmount;
  final double availableBalance;
  final String publicKeyAddress;

  WithdrawScreen({
    required this.withdrawalAmount,
    required this.availableBalance,
    required this.publicKeyAddress,
  });
  // void main() async {
  //   bool success = await tronService.swapTrxToUsdt(
  //     publicKeyAddress, // Your TRX wallet
  //     // "TQrfKBBQFAE8UR3MEiuhHhDymmvijAfPnw", // Your TRX wallet
  //     totalWithdrawalAmount,
  //   );
  //
  //   if (success) {
  //     print("TRX swapped to USDT successfully!");
  //   } else {
  //     print("Swap failed.");
  //   }
  // }

  Future<double> fetchTRXtoUSDTConversionRate() async {
    const String apiUrl =
        'https://min-api.cryptocompare.com/data/pricemulti?fsyms=TRX&tsyms=USDT';

    try {
      // Make the HTTP GET request to the API
      final response = await http.get(Uri.parse(apiUrl));

      // Check if the response is successful
      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);

        // Extract the TRX to USDT rate
        double trxToUsdtRate = data['TRX']['USDT'].toDouble();

        // Return the rate
        return trxToUsdtRate;
      } else {
        // Handle API errors
        throw Exception(
            'Failed to fetch TRX to USDT rate. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network errors)
      throw Exception('Error fetching TRX to USDT rate: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TronService tronService = TronService();

    // Fixed transaction fee of $1
    double transactionFee = 1.0;
    double totalWithdrawalAmount = withdrawalAmount - transactionFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.to(() => WithdrawPage());
          },
        ),
        title: const Text(
          'Withdraw',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {
              // Help action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${withdrawalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Available Balance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildRowQuantity(
                      'Quantity', '${availableBalance.toStringAsFixed(2)} USD'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Withdrawal Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCard(
              child: Column(
                children: [
                  _buildRowLabelValue('Address', publicKeyAddress),
                  const Divider(),
                  _buildRow('Withdrawal Amount',
                      '\$${withdrawalAmount.toStringAsFixed(2)}'),
                  const Divider(),
                  _buildRow('Transaction Fee',
                      '\$${transactionFee.toStringAsFixed(2)}'), // Fixed fee
                  const Divider(),
                  _buildRow('Total Withdrawal Amount',
                      '\$${totalWithdrawalAmount.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const Spacer(),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                // Show loading dialog
                Get.dialog(
                  WillPopScope(
                    onWillPop: () async => false,
                    child: const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text("Please wait..."),
                        ],
                      ),
                    ),
                  ),
                  barrierDismissible: false,
                );

                try {
                  // Fetch the TRX to USDT conversion rate
                  double trxToUsdtRate = await fetchTRXtoUSDTConversionRate();

                  // Convert the withdrawal amount (in USD) to TRX
                  double withdrawalAmountInTrx = withdrawalAmount / trxToUsdtRate;

                  // Perform the transaction with the converted TRX amount
                  // Perform the transaction with the converted TRX amount
                  bool success = await tronService.swapTrxToUsdt(
                    publicKeyAddress,
                    withdrawalAmountInTrx.toInt(), // Pass the TRX amount
                  );
                  // bool success = transactionResult['success'];
                  // String transactionId = transactionResult['transactionId'];
                  // String receiverAddress = transactionResult['receiverAddress'];

                  // Close the loading dialog
                  Get.back();

                  if (success) {
                    // Save transaction details to Firebase Firestore
                    final firebaseUser = FirebaseAuth.instance.currentUser;
                    if (firebaseUser != null) {
                      FirebaseFirestore.instance
                          .collection('Transactions')
                          .doc(firebaseUser.email) // Use the user's email as the document ID
                          .collection('transactions') // Sub collection for transactions
                          .add({
                        // 'transactionId': transactionId,
                       // 'SenderAddress': publicKey,
                        'amount': withdrawalAmount,
                        'receiverAddress': publicKeyAddress,
                        'timestamp': FieldValue.serverTimestamp(), // Add server timestamp
                      });
                    }

                    // Show success SnackBar
                    Get.snackbar(
                      "Success",
                      "Transaction successful!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );

                    // Navigate to the success screen
                    Get.to(const WalletTransactionSuccess());
                  } else {
                    // Show failure SnackBar
                    Get.snackbar(
                      "Error",
                      "Transaction failed. Please try again.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                } catch (e) {
                  // Close the loading dialog in case of an error
                  Get.back();

                  // Show error SnackBar
                  Get.snackbar(
                    "Error",
                    "An unexpected error occurred: ${e.toString()}",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Confirm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  _buildRowLabelValue(String label, String value) {
    return Row(
      //crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        //SizedBox(width: 2), // Add some spacing between label and value
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRowQuantity(String label, String value) {
    List<String> valueParts =
        value.split(' '); // Amount aur currency alag karne ke liye
    String amount = valueParts[0]; // Amount part
    String currency = valueParts.length > 1
        ? valueParts.sublist(1).join(' ')
        : ''; // Currency part
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              amount, // Sirf amount bold hoga
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              currency, // Currency ko alag rakha gya hai
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}
