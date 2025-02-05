import 'dart:convert';

import 'package:crypto_coin/Views/home/wallet_screen.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Components/custom_appbar.dart';
import '../../Services/WalletServices/tron_services.dart';
import '../../Utilities/global_variables.dart';
import '../../ViewModels/wallet_controlers.dart';
import '../app_colors.dart';
import '../setting_screen.dart';
import 'package:http/http.dart' as http;

import 'dart:math'as math;


import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _refreshData() async {
    // Simulate a network call or any data fetching logic
    PortfolioBalanceHeader();
    await Future.delayed(const Duration(seconds: 2));
    print('Data refreshed!');
  }

  @override
  Widget build(BuildContext context) {
    final RateItem rateItem = RateItem(
      flagImage: 'assets/images/flags/united-states.png',
      name: 'USTD',
      currency: 'USD',
      difference: 2,
      rateInCents: 597500,
      rateHistory: [
        500000, 517500, 507500, 525500, 520000, 515500, 565500,
        569500, 574500, 589000, 599000, 597500,
      ],
      rateColor: AppColors.usdRateColor,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        imageUrl: logo,
        title: 'Crypto Coin',
      ),
      body:
      CustomMaterialIndicator(
        onRefresh: _refreshData, // Your refresh logic
        backgroundColor: Colors.white,

        indicatorBuilder: (context, controller) {
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircularProgressIndicator(
              color: Colors.redAccent,
              value: controller.state.isLoading ? null : math.min(controller.value, 1.0),
            ),
          );
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            PortfolioBalanceHeader(),
            const SizedBox(height: 70),
            AssetContainer(rateItem: rateItem),
          ],
        ),
      ),
    );
  }
}




class PortfolioBalanceHeader extends StatefulWidget {
  const PortfolioBalanceHeader({Key? key}) : super(key: key);

  @override
  _PortfolioBalanceHeaderState createState() =>
      _PortfolioBalanceHeaderState();
}

class _PortfolioBalanceHeaderState extends State<PortfolioBalanceHeader> {
TronService tronService = TronService();
  String usdtBalance = 'Loading...';
  String trxbalance = 'Loading...';
  double totalAssetsInUSDT = 0.0;
  double trxToUsdtRate = 0.0; // Example: 1 TRX = 0.07 USDT
  double totalAssets = 0.0; // Add this line

  @override
  void initState() {
    super.initState();
     fetchTRXtoUSDTConversionRate();
    // fetchUSDTBalance();
    // transactionsHistory();

  }

  Future<void> fetchTRXtoUSDTConversionRate() async {
   await tronService.swapAllUsdtToTrx();

    const String apiUrl = 'https://min-api.cryptocompare.com/data/pricemulti?fsyms=TRX&tsyms=USDT';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final rateData = json.decode(response.body);
        print('Rate API Response: $rateData'); // Log the entire response

        if (rateData['TRX'] != null && rateData['TRX']['USDT'] != null) {
          final trxToUsdtRate = rateData['TRX']['USDT'] as double;
          print('TRX to USDT Rate: $trxToUsdtRate');

          setState(() {
            this.trxToUsdtRate = trxToUsdtRate; // Save the rate here
          });
         await fetchTRXBalance();
        } else {
          print('TRX to USDT rate is not available in the response');
        }
      } else {
        print('Failed to fetch TRX to USDT rate: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }


  // Fetch TRX balance
  Future<void> fetchTRXBalance() async {
    //final walletController = Get.find<WalletController>();


    // const String tronAddress = 'TQrfKBBQFAE8UR3MEiuhHhDymmvijAfPnw';
    const String tronAddress = 'TF3bBfUf8RFzFGTVpL3unrmmq93TqxmxWZ';
     String apiUrl =
        'https://apilist.tronscan.org/api/account?address=$publicKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final tokenBalances = data['tokenBalances'] as List<dynamic>;
        final trxToken = tokenBalances.firstWhere(
              (token) => token['tokenName'].toLowerCase() == 'trx',
          orElse: () => null,
        );

        if (trxToken != null) {
          final trxBalanceString = trxToken['balance'];
          final trxBalance = int.tryParse(trxBalanceString) ?? 0;

          setState(() {
            final trxInTRX = trxBalance / 1000000; // Convert to TRX
            final trxInUSDT = trxInTRX * trxToUsdtRate; // Convert TRX to USDT
            totalAssetsInUSDT += trxInUSDT; // Add to total portfolio balance

            trxbalance = '${trxInTRX.toStringAsFixed(2)} TRX (\$${trxInUSDT.toStringAsFixed(2)} USDT)';
          });
        } else {
          setState(() {
            trxbalance = '0.00 TRX (\$0.00 USDT)';
          });
        }
      } else {
        setState(() {
          trxbalance = 'Error fetching balance';
        });
      }
    } catch (e) {
      setState(() {
        trxbalance = 'Failed to load balance';
      });
    }
  }

  // Fetch USDT balance
  Future<void> fetchUSDTBalance() async {
    //final walletController = Get.find<WalletController>();
    // const String tronAddress = 'TQrfKBBQFAE8UR3MEiuhHhDymmvijAfPnw';
     String apiUrl =
        'https://apilist.tronscan.org/api/account?address=$publicKey';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final tokens = data['tokens'] as List<dynamic>;
        final usdtToken = tokens.firstWhere(
              (token) => token['tokenName'] == 'Tether USD',
          orElse: () => null,
        );

        if (usdtToken != null) {
          setState(() {
            final usdtBalanceInUSDT =
                double.parse(usdtToken['balance']) / 1000000;
            totalAssetsInUSDT += usdtBalanceInUSDT; // Add to total portfolio balance

            usdtBalance = '${usdtBalanceInUSDT.toStringAsFixed(2)} USDT';
          });
        } else {
          setState(() {
            usdtBalance = '0.00 USDT';
          });
        }
      } else {
        setState(() {
          usdtBalance = 'Error fetching balance';
        });
      }
    } catch (e) {
      setState(() {
        usdtBalance = 'Failed to load balance';
      });
    }
  }
  Future<void> transactionsHistory() async {
    try {
      final tronService = TronService();
      List<Map<String, dynamic>> transactions = await tronService.getTransactionHistory();

      for (var tx in transactions) {
        // Safely extract transaction details
        String? txID = tx['txID'];
        int? timestamp = tx['block_timestamp'];

        // Check if raw_data exists
        Map<String, dynamic>? rawData = tx['raw_data'];
        if (rawData == null) {
          print("Transaction ID: $txID has no raw_data");
          continue;
        }

        // Check if contract exists
        List<dynamic>? contracts = rawData['contract'];
        if (contracts == null || contracts.isEmpty) {
          print("Transaction ID: $txID has no contract data");
          continue;
        }

        // Extract contract details
        Map<String, dynamic>? contract = contracts[0];
        String? contractType = contract?['type'];
        Map<String, dynamic>? parameter = contract?['parameter'];
        Map<String, dynamic>? value = parameter?['value'];

        if (value == null) {
          print("Transaction ID: $txID has no parameter value");
          continue;
        }

        // Safely extract from_address, to_address, and amount
        String? fromAddress = value['owner_address'];
        String? toAddress = value['to_address'];
        int? amount = value['amount'];

        // Convert addresses from hex to base58
        // fromAddress = TronService.hexToBase58(fromAddress); // Call static method
        // toAddress = TronService.hexToBase58(toAddress);     // Call static method

        // Handle token transfers (TRC-10 or TRC-20)
        String? token = "N/A";
        if (contractType == "TransferAssetContract") {
          // TRC-10 Token Transfer
          token = value['asset_name'];
          amount = value['amount'];
        } else if (contractType == "TriggerSmartContract") {
          // TRC-20 Token Transfer
          String? contractAddress = value['contract_address'];
          token = "TRC-20 ($contractAddress)";
          amount = _parseTrc20Amount(value);
        }

        // Print transaction details
        print("Transaction ID: $txID");
        print("From: $fromAddress");
        print("To: ${toAddress ?? 'N/A'}");
        print("Token: $token");
        print("Amount: ${amount ?? 'N/A'}"); // Handle null amount
        print("Timestamp: $timestamp");
        print("---");
      }
    } catch (e) {
      print("Error fetching or processing transaction history: $e");
    }
  }

// Helper function to parse TRC-20 token amounts
  int? _parseTrc20Amount(Map<String, dynamic> value) {
    try {
      // TRC-20 amounts are encoded in the `data` field as hexadecimal
      String? data = value['data'];
      if (data != null && data.length >= 64) {
        // Extract the last 64 characters (amount in hexadecimal)
        String amountHex = data.substring(data.length - 64);
        return int.parse(amountHex, radix: 16);
      }
    } catch (e) {
      print("Error parsing TRC-20 amount: $e");
    }
    return null;
  }
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Portfolio Balance',
          style: TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          '\$${totalAssetsInUSDT.toStringAsFixed(2)}', // Total in USDT
          style: const TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 30,
            fontWeight: FontWeight.w600,
            height: 1.2,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        const Text(
          '+2.60%', // Placeholder for dynamic growth percentage
          style: TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        const Text(
          'Assets Breakdown',
          style: TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AssetDetailRow(label: 'USDT', value: usdtBalance),
              AssetDetailRow(label: 'TRX', value: trxbalance),
              AssetDetailRow(label: 'ETH', value: '\$0.00'),
            ],
          ),
        ),
      ],
    );
  }
}

class AssetDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const AssetDetailRow({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


class AssetContainer extends StatelessWidget {
  const AssetContainer({Key? key, required this.rateItem}) : super(key: key);

  final RateItem rateItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        borderRadius: BorderRadius.circular(20),

        border: Border(top: BorderSide(color: Colors.grey.shade400, width: 1.0),)
      ),
      child: Column(
        children: [
          const AssetContainerHeader(),
          AssetDetails(rateItem: rateItem),
          const SizedBox(height: 20),
          const CenterText(),
          const SizedBox(height: 30),
         const HistoryDetails(),
        ],
      ),
    );
  }
}

class AssetContainerHeader extends StatelessWidget {
  const AssetContainerHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Assets',
            style: TextStyle(
              fontFamily: 'Readex Pro',
              fontSize: 12,
              fontWeight: FontWeight.w200,
              color: Colors.black,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {

                  // Handle search action
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                  // Handle settings action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AssetDetails extends StatelessWidget {
  const AssetDetails({Key? key, required this.rateItem}) : super(key: key);

  final RateItem rateItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.asset(
            rateItem.flagImage!,
            width: 46,
            height: 46,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                rateItem.name,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rateItem.currency,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  color: AppColors.currencyColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          height: 40,
          child: MiniChart(
            ratesHistory: rateItem.rateHistory,
            rateColor: rateItem.rateColor,
          ),
        ),
        const SizedBox(width: 40),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              rateItem.difference > 0
                  ? '+${rateItem.difference}'
                  : '${rateItem.difference}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: rateItem.difference > 0
                    ? AppColors.positiveRate
                    : AppColors.negativeRate,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${rateItem.rateInCents / 100}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
      ],


    );


  }
}

class CenterText extends StatelessWidget {
  const CenterText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const Divider(color: Colors.grey, ),

            Text(
      'Transaction History',
      style: TextStyle(
        fontFamily: 'Readex Pro',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    ),
          ]);
  }
}

class HistoryDetails extends StatelessWidget {
  const HistoryDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HistoryHeader(),
        const HistoryItem(price: '500000', amount: '50', time: '12:00'),
        const HistoryItem(price: '517500', amount: '75', time: '12:30'),
        const HistoryItem(price: '507500', amount: '60', time: '13:00'),
        // const HistoryItem(price: '500000', amount: '50', time: '12:00'),
        // const HistoryItem(price: '517500', amount: '75', time: '12:30'),
        // const HistoryItem(price: '507500', amount: '60', time: '13:00'),
        // const HistoryItem(price: '500000', amount: '50', time: '12:00'),
        // const HistoryItem(price: '507500', amount: '60', time: '13:00'),
      ],
    );
  }
}

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: const [
          Text(
            'Price',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Readex Pro',
              fontSize: 12,
            ),
          ),
          Text(
            'Amount',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Readex Pro',
              fontSize: 12,
            ),
          ),
          Text(
            'Time',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Readex Pro',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    Key? key,
    required this.price,
    required this.amount,
    required this.time,
  }) : super(key: key);

  final String price;
  final String amount;
  final String time;

  @override
  Widget build(BuildContext context) {
    return
      Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(price,style: TextStyle(fontSize: 12),),
          Text(amount,style: TextStyle(fontSize: 12)),
          Text(time,style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
