import 'dart:async';
import 'dart:convert';
import 'package:crypto_coin/Views/home/wallet_screen.dart';
import 'package:crypto_coin/Views/home/widgets/resource_row.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import '../../Components/custom_appbar.dart';
import '../../Services/WalletServices/tron_services.dart';
import '../../Utilities/global_variables.dart';
import '../app_colors.dart';
import '../setting_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:math'as math;
import 'package:shared_preferences/shared_preferences.dart';

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
        title: 'C Coin',
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
  double trxToUsdtRate = 0.0; // Example: 1 TRX = 0.07 USDT
  double totalAssets = 0.0; // Add this line
Map<String, dynamic>? resources;
// Add energy and bandwidth variables
int energy = 0;
int bandwidth = 0;
  bool isLoading = true;
  bool _isDialogShown = false; // Flag to track if the dialog has been shown
  @override
  void initState() {
    super.initState();

     fetchTRXtoUSDTConversionRate();
    // fetchUSDTBalance();
    // transactionsHistory();
    fetchResources().then((_) {
      _checkIfDialogShown(); // Ensure this is called after resources are fetched
    });
  }
  Future _checkIfDialogShown() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        _isDialogShown = prefs.getBool('isDialogShown') ?? false;
      });

      // Show the dialog only if it hasn't been shown before
      if (!_isDialogShown) {
        _showActivationDialog(context);
      }
    } catch (e) {
      print("Error checking dialog state: $e");
    }
  }
  void _showActivationDialog(BuildContext context) {
    int countdownDuration = 120; // 2 minutes in seconds
    bool isCloseButtonEnabled = false;

    print("Attempting to show activation dialog..."); // Debug log

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Timer.periodic(Duration(seconds: 1), (timer) {
              if (countdownDuration > 0) {
                setState(() {
                  countdownDuration--;
                });
              } else {
                timer.cancel(); // Stop the timer when countdown reaches 0
                setState(() {
                  isCloseButtonEnabled = true;
                });
              }
            });

            String formatTime(int seconds) {
              int minutes = seconds ~/ 60;
              int remainingSeconds = seconds % 60;
              return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
            }

            return AlertDialog(
              title: Text('Account Activation Required'),
              content: Text(
                'Your account is not activated yet. To activate your account, transfer 100 TRX to your current TRON address. After receiving 100 TRX, immediately click on Energy and stake your 100 TRX to avoid network fees. Otherwise, you will incur a cost of 5 to 10 USDT per transaction.',
                style: TextStyle(fontSize: 14),
              ),
              actions: [
                TextButton(
                  onPressed: isCloseButtonEnabled
                      ? () {
                    Navigator.of(context).pop(); // Close the dialog
                  }
                      : null, // Disable the button until the countdown finishes
                  child: Text(
                    isCloseButtonEnabled ? 'Close' : 'Close (${formatTime(countdownDuration)})',
                    style: TextStyle(
                      color: isCloseButtonEnabled ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      print("Dialog closed. Saving dialog state..."); // Debug log
      _saveDialogState(true);
    });
  }

  Future<void> _saveDialogState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDialogShown', value); // Save the state to persistent storage
  }


  Future<void> fetchTRXtoUSDTConversionRate() async {
    totalAssetsInUSDT = 0.0; // Reset total assets
    await tronService.swapAllUsdtToTrx();// Swap all USDT to TRX

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
    // const String tronAddress = 'TF3bBfUf8RFzFGTVpL3unrmmq93TqxmxWZ';
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
  Future<void> fetchResources() async {
    TronService tronService = TronService();
    Map<String, dynamic>? fetchedResources = await tronService.getResources();
   await _checkIfDialogShown();
    setState(() {

      resources = fetchedResources;
      isLoading = false;
    });
  }

// Future<void> stakeTRXForResources({required String resourceType}) async {
//   const int amountToStake = 1000000; // 1 TRX in SUN
//   final String apiUrl = 'https://api.trongrid.io/wallet/freezebalance';
//
//   final Map<String, dynamic> requestBody = {
//     "owner_address": publicKey,
//     "frozen_balance": amountToStake,
//     "resource": resourceType, // "ENERGY" or "BANDWIDTH"
//     "visible": true,
//   };
//
//   try {
//     final response = await http.post(
//       Uri.parse(apiUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(requestBody),
//     );
//
//     if (response.statusCode == 200) {
//       print('Staking successful for $resourceType');
//       fetchResources(); // Refresh resources after staking
//     } else {
//       print('Staking failed: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Exception while staking: $e');
//   }
// }

  void stakeTrxExample(String resourceName) async {
    TronService tronService = TronService();

    // Stake 10 TRX for ENERGY
    bool success = await tronService.stakeTrx(resourceName, 100);
    if (success) {
      print("TRX staked successfully!");
    } else {
      print("Failed to stake TRX.");
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
        // Existing Portfolio Balance Section
        const Text(
          'Portfolio Balance',
          style: TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 5),
        Text(
          '\$${totalAssetsInUSDT.toStringAsFixed(1)}', // Total in USDT
          style: const TextStyle(
            fontFamily: 'Readex Pro',
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),

        // New Resources Section
        const SizedBox(height: 20),
        const Text(
          'Resources',
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
          child:Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 5,
              children: [
                ResourceRow(
                  label: 'Energy',
                  value: '${resources?['energy']['available'] ?? "0"}',
                  icon: Icons.flash_on, // Lightning bolt icon
                  valueColor: resources?['energy']['available'] == 0
                      ? Colors.red
                      : Colors.green, // Red if no energy available
                  onTap: () => stakeTrxExample("ENERGY"),
                ),
                SizedBox(height: 10),
                ResourceRow(
                  label: 'Bandwidth',
                  value: '${resources?['bandwidth']['available'] ?? "0"}',
                  icon: Icons.network_wifi, // Network icon
                  valueColor: resources?['bandwidth']['available'] == 0
                      ? Colors.red
                      : Colors.green, // Red if no bandwidth available
                  onTap: () => stakeTrxExample("BANDWIDTH"),
                ),
              ],
            ),
          )
        ),
      ],
    );
  }}

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
          // const AssetContainerHeader(),
          // AssetDetails(rateItem: rateItem),
          const SizedBox(height: 10),
          const CenterText(),
          const SizedBox(height: 30),
         const HistoryDetails(),
        ],
      ),
    );
  }
}

// class AssetContainerHeader extends StatelessWidget {
//   const AssetContainerHeader({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             'My Assets',
//             style: TextStyle(
//               fontFamily: 'Readex Pro',
//               fontSize: 12,
//               fontWeight: FontWeight.w200,
//               color: Colors.black,
//             ),
//           ),
//           Row(
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () {
//
//                   // Handle search action
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.settings),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SettingsPage()),
//                   );
//                   // Handle settings action
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class AssetDetails extends StatelessWidget {
//   const AssetDetails({Key? key, required this.rateItem}) : super(key: key);
//
//   final RateItem rateItem;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Image.asset(
//             rateItem.flagImage!,
//             width: 46,
//             height: 46,
//           ),
//         ),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 rateItem.name,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 rateItem.currency,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 10,
//                   color: AppColors.currencyColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           width: 80,
//           height: 40,
//           child: MiniChart(
//             ratesHistory: rateItem.rateHistory,
//             rateColor: rateItem.rateColor,
//           ),
//         ),
//         const SizedBox(width: 40),
//         Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Text(
//               rateItem.difference > 0
//                   ? '+${rateItem.difference}'
//                   : '${rateItem.difference}',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: rateItem.difference > 0
//                     ? AppColors.positiveRate
//                     : AppColors.negativeRate,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '${rateItem.rateInCents / 100}',
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//                 fontSize: 16,
//                 color: Colors.black,
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(width: 20),
//       ],
//
//
//     );
//
//
//   }
// }

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



class HistoryDetails extends StatefulWidget {
  const HistoryDetails({Key? key}) : super(key: key);

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
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

          return Column(
            children: [
              const HistoryHeader(),
              ...transactions.map((tx) => HistoryItem(
                ownerAddress: tx.ownerAddress,
                amount: tx.getAmountInUSD(tronPriceInUSD).toStringAsFixed(2),
                time: '${tx.timestamp.hour}:${tx.timestamp.minute}',
                status: tx.status,
              )),
            ],
          );
        }
      },
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
            'Owner Address',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'Amount (USD)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'Time',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(
            'Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    Key? key,
    required this.ownerAddress,
    required this.amount,
    required this.time,
    required this.status,
  }) : super(key: key);

  final String ownerAddress;
  final String amount;
  final String time;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              ownerAddress,
              style: const TextStyle(fontSize: 8),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(amount, style: const TextStyle(fontSize: 12)),
          // Text(time, style: const TextStyle(fontSize: 12)),
          SizedBox(width: 25,),
          Text(status, style: const TextStyle(fontSize: 12)),
        ],
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
      print(jsonData); // Log the full JSON response
      final List<dynamic> transactionsData = jsonData['data'];

      return transactionsData.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }}
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
    final trxAmount = frozenBalance / 1e6;
    return trxAmount * tronPriceInUSD;
  }
}