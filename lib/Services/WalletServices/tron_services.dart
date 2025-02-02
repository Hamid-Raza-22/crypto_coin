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
  Future<bool> sendTrx(String fromAddress, String toAddress, double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendTronTransaction'),
        body: {
          'fromAddress': fromAddress, // Add fromAddress
          'toAddress': toAddress,
          'amount': amount.toString(),
        },
      );
      // ... rest of the code

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
  Future<bool> sendTrc20(String toAddress, String amount, String contractAddress) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendTrc20Transaction'),
        body: {

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
  Future<bool> swapTrxToUsdt(String fromAddress, String receiverAddress, int trxAmount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/swapTrxToUsdt'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "fromAddress": fromAddress.toString(), // Ensure it's a string
          "receiverAddress": receiverAddress.toString(), // Ensure it's a string
          "trxAmount": trxAmount.toInt() // Ensure it's a double

        }),
      );
      print("From Address Type: ${fromAddress.runtimeType}");
      print("Receiver Address Type: ${receiverAddress.runtimeType}");
      print("TRX Amount Type: ${trxAmount.runtimeType}");


      if (response.statusCode == 200) {
        print("Swap successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error swapping TRX to USDT: $e");
      return false;
    }
  }
  Future<bool> withdraw( String receiverAddress, double trxAmount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/withdraw'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'recipientAddress': receiverAddress,
          'trxAmount': trxAmount,
        }),
      );

      if (response.statusCode == 200) {
        print("Swap successful: ${response.body}");
        return true;
      } else {
        print("Error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error swapping wit TRX to USDT: $e");
      return false;
    }
  }
}