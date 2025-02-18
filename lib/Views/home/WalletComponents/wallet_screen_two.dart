import 'package:crypto_coin/Views/home/WalletComponents/wallet_controller.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_deposit_screen.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdraw_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../Components/custom_button.dart';
import '../../../Components/custom_editable_menu_option.dart';
import '../../../Utilities/global_variables.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../ViewModels/user_provider_logic.dart';
class WalletScreenTwo extends StatelessWidget {
  final WalletController controller = Get.put(WalletController());
  final UserProvider userProvider = Get.put(UserProvider());

   WalletScreenTwo({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

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
        _buildCardDetail('Card Holder', userProvider.email.value),
       // _buildCardDetail('Expire', '03/29'),
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
    return FutureBuilder<List<Transaction>>(
      future: TronApiService.fetchTransactions(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions found.'));
        } else {
          final transactions = snapshot.data!;
          const tronPriceInUSD = 0.12; // Example price: 1 TRX = $0.12

          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: transactions.map((tx) {
              return _buildTransactionTile(
                title: tx.status, // Status in the title
                subtitle: tx.ownerAddress, // Owner address in the subtitle
                amount: '${tx.getAmountInUSD(tronPriceInUSD).toStringAsFixed(2)} USD', // Amount in USD
                icon: _getStatusIcon(tx.status), // Icon based on status
              );
            }).toList(),
          );
        }
      },
    );
  }

// Helper method to determine the icon based on the transaction status
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'SUCCESS':
        return FontAwesomeIcons.checkCircle;
      case 'FAILED':
        return FontAwesomeIcons.timesCircle;
      case 'UNKNOWN':
      default:
        return FontAwesomeIcons.clock;
    }
  }

// Method to build individual transaction tiles
  Widget _buildTransactionTile({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.grey),
      ),
      title: Text(
        title, // Status
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle, // Owner Address
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: Text(
        amount, // Amount in USD
        style: TextStyle(
          color: amount.startsWith('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }}
class TransactionList extends StatefulWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _transactionsFuture = TronApiService.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Transaction>>(
      future: _transactionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No transactions found.'));
        } else {
          final transactions = snapshot.data!;
          const tronPriceInUSD = 0.12; // Example price: 1 TRX = $0.12

          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: transactions.map((tx) {
              return _buildTransactionTile(
                title: tx.status, // Status
                subtitle: tx.ownerAddress, // Owner Address
                amount: '${tx.getAmountInUSD(tronPriceInUSD).toStringAsFixed(2)} USD', // Amount in USD
                icon: _getStatusIcon(tx.status), // Icon based on status
              );
            }).toList(),
          );
        }
      },
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'SUCCESS':
        return FontAwesomeIcons.checkCircle;
      case 'FAILED':
        return FontAwesomeIcons.timesCircle;
      case 'UNKNOWN':
      default:
        return FontAwesomeIcons.clock;
    }
  }

  Widget _buildTransactionTile({
    required String title,
    required String subtitle,
    required String amount,
    required IconData icon,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade200,
        child: Icon(icon, color: Colors.grey),
      ),
      title: Text(
        title, // Status
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle, // Owner Address
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: Text(
        amount, // Amount in USD
        style: TextStyle(
          color: amount.startsWith('-') ? Colors.red : Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
class TronApiService {
  static const String baseUrl = "https://api.trongrid.io/v1/accounts";
  // static const String ownerAddress = "TQrfKBBQFAE8UR3MEiuhHhDymmvijAfPnw";

  static Future<List<Transaction>> fetchTransactions() async {
    final response = await http.get(Uri.parse('$baseUrl/$publicKey/transactions'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List<dynamic> transactionsData = jsonData['data'];

      // Parse each transaction into a Transaction object
      return transactionsData.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }
}

class Transaction {
  final String ownerAddress;
  final int frozenBalance; // in SUN
  final String status;
  final DateTime timestamp;

  Transaction({
    required this.ownerAddress,
    required this.frozenBalance,
    required this.status,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    try {
      final rawContract = json['raw_data']['contract'][0]['parameter']['value'];
      final ret = json['ret'][0];

      return Transaction(
        ownerAddress: rawContract['owner_address'] ?? 'Unknown Address',
        frozenBalance: rawContract['frozen_balance'] ?? 0,
        status: ret['contractRet'] ?? 'UNKNOWN',
        timestamp: DateTime.fromMillisecondsSinceEpoch(json['block_timestamp']),
      );
    } catch (e) {
      print('Error parsing transaction: $e');
      return Transaction(
        ownerAddress: 'Unknown Address',
        frozenBalance: 0,
        status: 'UNKNOWN',
        timestamp: DateTime.now(),
      );
    }
  }

  // Convert frozen balance (SUN) to USD
  double getAmountInUSD(double tronPriceInUSD) {
    final trxAmount = frozenBalance / 1e6; // Convert SUN to TRX
    return trxAmount * tronPriceInUSD;
  }
}