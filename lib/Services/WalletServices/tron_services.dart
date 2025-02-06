import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../Utilities/global_variables.dart';

const WTRX = "TNUC9Qb1rRpS5CbWLmNMxXBjyFoydXjWFR"; // Wrapped TRX Address
const USDT = "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t"; // USDT Contract
const SUNSWAP_ROUTER =
    "TXF1xDbVGdxFGbovmmmXvBGu8ZiE3Lq4mR"; // SunSwap Router V2

class TronService {
  final String baseUrl =
      "https://us-central1-crypto-coin-f8437.cloudfunctions.net";
  // 1. Get Balance

  Future<double?> getTronBalance() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/getTronBalance?address=$publicKey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['balance'] == null) {
          if (kDebugMode) {
            print("Balance not found in response");
          }
          return null;
        }

        if (data['balance'] is int) {
          return (data['balance'] as int) / 1e6; // Convert Sun to TRX
        } else if (data['balance'] is String) {
          return double.tryParse(data['balance']) ?? 0.0;
        } else {
          print("Unexpected data type for balance: ${data['balance']}");
          return null;
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching balance: $e");
      return null;
    }
  }

  // 2. Send TRX

  Future<bool> sendTrx(
    String toAddress,
    double amount,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendTronTransaction'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fromAddress': publicKey!,
          'toAddress': toAddress,
          'amount': amount.toString(),
          'privateKey': privateKey,
        }),
      );

      if (response.statusCode == 200) {
        print("Transaction successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending TRX: $e");
      return false;
    }
  }

  // 3. Send TRC-20 Tokens

  Future<bool> sendTrc20(
      String toAddress, String amount, String contractAddress) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendTrc20Transaction'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'toAddress': toAddress,
          'amount': amount,
          'contractAddress': contractAddress,
          'privateKey': privateKey,
        }),
      );

      if (response.statusCode == 200) {
        print("TRC-20 Transaction successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending TRC-20 tokens: $e");
      return false;
    }
  }

  // 4. Generate Wallet

  Future<Map<String, String>> generateWallet() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/generateWallet'));

      if (response.statusCode == 200) {
        Map<String, dynamic> walletData = jsonDecode(response.body);

        String address = walletData['address'];
        String privateKey = walletData['privateKey'];

        return {'address': address, 'privateKey': privateKey};
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return {};
      }
    } catch (e) {
      print("Error generating wallet: $e");
      return {};
    }
  }

  // 5. Swap TRX to USDT

  Future<bool> swapTrxToUsdt(String receiverAddress, int trxAmount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/swapTrxToUsdt'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fromAddress': publicKey,
          'receiverAddress': receiverAddress,
          'trxAmount': trxAmount,
          'privateKey': privateKey,
          'wtrx': WTRX,
          'usdt': USDT,
          'sunswapRouter': SUNSWAP_ROUTER,
        }),
      );

      if (response.statusCode == 200) {
        print("Swap successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error swapping TRX to USDT: $e");
      return false;
    }
  }

  // 6. Withdraw

  Future<bool> withdraw(String receiverAddress, double trxAmount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/withdraw'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'recipientAddress': receiverAddress,
          'trxAmount': trxAmount,
          'privateKey': privateKey,
          'wtrx': WTRX,
          'usdt': USDT,
          'sunswapRouter': SUNSWAP_ROUTER,
        }),
      );

      if (response.statusCode == 200) {
        print("Withdrawal successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error withdrawing TRX: $e");
      return false;
    }
  }
  // 7. Get Transaction History

  Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    try {
      // Use TronGrid API to fetch transaction history
      final String tronGridUrl =
          "https://api.trongrid.io/v1/accounts/$publicKey/transactions";
      final response = await http.get(Uri.parse(tronGridUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data'] is List) {
          // Parse and return the list of transactions
          List<dynamic> transactions = data['data'];
          return transactions.map((tx) => tx as Map<String, dynamic>).toList();
        } else {
          print("No transaction data found in response");
          return [];
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching transaction history: $e");
      return [];
    }
  }

// 8. Swap All USDT to TRX
  Future<bool> swapAllUsdtToTrx() async {
    try {
      // Fetch the USDT balance of the wallet
      final response = await http.post(
        Uri.parse(
            'https://apilist.tronscan.org/api/account?address=$publicKey'),
        //Uri.parse('$baseUrl/getUsdtBalance'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'address': publicKey!,
          'contractAddress': USDT,
        }),
      );

      if (response.statusCode != 200) {
        print("Error fetching USDT balance: ${response.body}");
        return false;
      }

      final data = jsonDecode(response.body);
      if (data['balance'] == null ||
          double.tryParse(data['balance'].toString()) == null) {
        print("No USDT balance found or invalid balance format");
        return false;
      }

      double usdtBalance = double.parse(data['balance'].toString());
      if (usdtBalance <= 0) {
        print("No USDT balance available in the wallet");
        return false;
      }

      // Perform the swap
      final swapResponse = await http.post(
        Uri.parse('$baseUrl/swapAllUsdtToTrx'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fromAddress': publicKey!,
          'receiverAddress': publicKey,
          'usdtAmount': usdtBalance.toString(),
          'privateKey': privateKey,
          'wtrx': WTRX,
          'usdt': USDT,
          'sunswapRouter': SUNSWAP_ROUTER,
        }),
      );

      if (swapResponse.statusCode == 200) {
        print("Swap successful: ${swapResponse.body}");
        return true;
      } else {
        print(
            "Error swapping USDT to TRX: ${swapResponse.statusCode} - ${swapResponse.body}");
        return false;
      }
    } catch (e) {
      print("Error during swapAllUsdtToTrx: $e");
      return false;
    }
  }
  // 9. Stake TRX for Energy or Bandwidth
  Future<bool> stakeTrx(String resourceType, double amount) async {
    try {
      // Validate resource type
      if (resourceType != 'ENERGY' && resourceType != 'BANDWIDTH') {
        print("Invalid resource type: $resourceType");
        return false;
      }
      // Call the backend API to stake TRX
      final response = await http.post(
        Uri.parse('$baseUrl/stakeTrx'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fromAddress': publicKey,
          'privateKey': privateKey,
          'resourceType': resourceType,
          'amount': amount.toInt(), // Amount in TRX
        }),
      );

      // Handle the response
      if (response.statusCode == 200) {
        print("Staking successful: ${response.body}");
        return true;
      } else {
        print("Error staking TRX: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error during staking TRX: $e");
      return false;
    }
  }
  // 10. Get Energy and Bandwidth Resources
  Future<Map<String, dynamic>?> getResources() async {
    try {
      // Call the backend API to fetch resource details
      final response = await http.get(
        Uri.parse('$baseUrl/getResources?address=$publicKey'),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Parse and return the resource details
        if (data['success'] == true) {
          return {
            'energy': {
              'limit': data['resources']['energy']['limit'],
              'used': data['resources']['energy']['used'],
              'available': data['resources']['energy']['available'],
            },
            'bandwidth': {
              'limit': data['resources']['bandwidth']['limit'],
              'used': data['resources']['bandwidth']['used'],
              'available': data['resources']['bandwidth']['available'],
            },
          };
        } else {
          print("Error: Resource data not found in response");
          return null;
        }
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching resources: $e");
      return null;
    }
  }
}
