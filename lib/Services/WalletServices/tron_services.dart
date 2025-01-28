import 'dart:convert';
import 'package:http/http.dart' as http;

class TronService {
  final String baseUrl =
      "https://us-central1-crypto-coin-f8437.cloudfunctions.net";

  // 1. Get Balance
  Future<double?> getTronBalance(String address) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/getTronBalance?address=$address'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle balance as an int or a double
        if (data['balance'] is int) {
          return (data['balance'] as int) / 1e6; // Convert Sun to TRX
        } else if (data['balance'] is String) {
          return double.tryParse(data['balance']) ?? 0.0;
        } else {
          print("Unexpected data type for balance: ${data['balance']}");
          return null;
        }
      } else {
        print("Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching balance: $e");
      return null;
    }
  }


  // 2. Send TRX
  Future<bool> sendTrx(String toAddress, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendTronTransaction'),
        body: {
          'toAddress': toAddress,
          'amount': amount.toString(),
        },
      );

      if (response.statusCode == 200) {
        print("Transaction successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending TRX: $e");
      return false;
    }
  }

  // 3. Send TRC-20 Tokens
  Future<bool> sendTrc20(String ownerAddress,String toAddress, String amount, String contractAddress) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendTrc20Transaction'),
        body: {
          'fromAddress': ownerAddress,
          'toAddress': toAddress,
          'amount': amount,
          'contractAddress': contractAddress,
        },
      );

      if (response.statusCode == 200) {
        print("TRC-20 Transaction successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending TRC-20 tokens: $e");
      return false;
    }
  }

  // 4. Generate Wallet
   generateWallet() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/generateWallet'));

      if (response.statusCode == 200) {
        // Successfully got a wallet response
        Map<String, dynamic> walletData = jsonDecode(response.body);

        String address = walletData['address'];
        String privateKey = walletData['privateKey'];

        // Print the generated wallet data
        print("Generated Wallet Address: $address");
        print("Generated Wallet Private Key: $privateKey");
      } else {
        print("Error: ${response.body}");
      }
    } catch (e) {
      print("Error generating wallet: $e");
    }
  }
}