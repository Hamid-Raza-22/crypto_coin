import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto; // We'll use this to sign the transaction
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdrwa_screen.dart';
import 'package:crypto_coin/Views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// //import 'package:hex/hex.dart';
// import 'package:convert/convert.dart';
 import 'package:base58check/base58check.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:pointycastle/api.dart'as pc;
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:pointycastle/signers/ecdsa_signer.dart';

import '../../../Services/WalletServices/tron_services.dart';


// import 'package:pointycastle/export.dart';

//import 'package:bs58check/bs58check.dart' as bs58check;
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




  bool isValidHex(String input) {
    final hexRegex = RegExp(r'^[0-9a-fA-F]+$');
    return input.length == 64 && hexRegex.hasMatch(input);
  }

  bool isValidBase58Check(String address) {
    try {
      Base58CheckCodec.bitcoin().decode(address);
      return true;
    } catch (e) {
      return false;
    }
  }

  String tronAddressToHex(String tronAddress) {
    // Ensure it's a valid Base58Check address
    if (!isValidBase58Check(tronAddress)) {
      throw FormatException("Invalid Base58Check string: $tronAddress");
    }

    // Decode Base58Check address to Base58CheckPayload
    final decodedPayload = Base58CheckCodec.bitcoin().decode(tronAddress);

    // Extract payload as List<int>
    final payloadBytes = decodedPayload.payload;

    // Add the '41' prefix
    final addressWithPrefix = [0x41] + payloadBytes;

    // Convert to hexadecimal string
    return hex.encode(addressWithPrefix);
  }



  Uint8List signTransaction(String privateKeyHex, Uint8List transactionHash) {
    final privateKey = BigInt.parse(privateKeyHex, radix: 16);
    final ecDomain = ECDomainParameters('secp256k1');
    final privateKeyParams = pc.PrivateKeyParameter(ECPrivateKey(privateKey, ecDomain));

    // Initialize secure random generator
    final secureRandom = _initializeSecureRandom();

    final signer = ECDSASigner();
    signer.init(true, pc.ParametersWithRandom(privateKeyParams, secureRandom));

    final ECSignature signature = signer.generateSignature(transactionHash) as ECSignature;

    final rBytes = _bigIntToBytes(signature.r, 32);
    final sBytes = _bigIntToBytes(signature.s, 32);
    return Uint8List.fromList([...rBytes, ...sBytes]);
  }

  pc.SecureRandom _initializeSecureRandom() {
    final secureRandom = FortunaRandom();

    // Seed FortunaRandom with system random numbers
    final seed = Uint8List.fromList(List<int>.generate(32, (_) => Random.secure().nextInt(256)));
    secureRandom.seed(pc.KeyParameter(seed));

    return secureRandom;
  }

  Uint8List _bigIntToBytes(BigInt bigInt, int size) {
    final bytes = bigInt.toUnsigned(256).toRadixString(16).padLeft(size * 2, '0');
    return Uint8List.fromList(List<int>.generate(bytes.length ~/ 2, (i) {
      return int.parse(bytes.substring(i * 2, i * 2 + 2), radix: 16);
    }));
  }


  Future<void> sendUSDT(String privateKey, int amount) async {
    if (!isValidHex(privateKey)) {
      print('Invalid private key. Must be a 64-character hexadecimal string.');
      return;
    }

    // Addresses
    const ownerAddress = 'TEGAcjUoR9W8mdKqXEWd7KNaWH8sTs8S1s';
    const toAddress = 'TKSRbKd1K8v62FLLeKeMd19joP1oxCPTjP';
    //const contractAddress = 'TLaGf5Cp9nbD5ednxz66oZfvZAX3as5eFf';
    const contractAddress = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';

    if (!isValidBase58Check(ownerAddress)) {
      print('Invalid owner address: $ownerAddress');
      return;
    }
    if (!isValidBase58Check(toAddress)) {
      print('Invalid to address: $toAddress');
      return;
    }
    if (!isValidBase58Check(contractAddress)) {
      print('Invalid contract address: $contractAddress');
      return;
    }

    // Convert all addresses to hex
    final ownerHex = tronAddressToHex(ownerAddress);
    final toHex = tronAddressToHex(toAddress);
    final contractHex = tronAddressToHex(contractAddress);

    print('Hex Encoded Owner Address: $ownerHex');
    print('Hex Encoded To Address: $toHex');
    print('Hex Encoded Contract Address: $contractHex');

    // API Payload
    final payload = {
      'owner_address': ownerHex,
      'to_address': toHex,
      'amount': (amount * 1e6).toInt(),
      'contract_address': contractHex,
    };

    const url = 'https://api.trongrid.io/wallet/createtransaction';


    // Step 1: Create the transaction
    final createResponse = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (createResponse.statusCode == 200) {
      final transaction = jsonDecode(createResponse.body);
      print('Transaction created successfully: ${transaction['txID']}');


// Step 2: Sign the transaction locally
      final transactionHash = Uint8List.fromList(
          transaction['raw_data_hex']
          .toString()
          .codeUnits); // Convert raw_data_hex to Uint8List
      final signature = signTransaction(privateKey, transactionHash);
      transaction['signature'] = [base64Encode(signature)];
      print('Raw Data Hex: ${transaction['raw_data_hex']}');
      //print('Decoded Raw Data: ${jsonDecode(transaction['raw_data'])}');
      print('Decoded Raw Data: ${transaction['raw_data']}');
      print('Signature: ${base64Encode(signature)}');

        // Step 3: Broadcast the transaction
        const broadcastUrl = 'https://api.trongrid.io/wallet/broadcasttransaction';
      try {
        final broadcastResponse = await http.post(
          Uri.parse(broadcastUrl),
          headers: {
            'Content-Type': 'application/json',
            'TRON-PRO-API-KEY': 'debb2987-653a-41dd-93b5-99efc99fa8a1',
          },
          body: jsonEncode(transaction),
        ).timeout(Duration(seconds: 30));

        print('Broadcast Response Status Code: ${broadcastResponse.statusCode}');
        print('Broadcast Response Body: ${broadcastResponse.body}');

        if (broadcastResponse.statusCode == 200) {
          final broadcastResult = jsonDecode(broadcastResponse.body);
          if (broadcastResult['result'] == true) {
            print('Transaction broadcasted successfully. TXID: ${transaction['txID']}');
          } else {
            print('Broadcast failed: ${broadcastResult}');
          }
        } else {
          print('Error broadcasting transaction: ${broadcastResponse.statusCode}');
          print('Response body: ${broadcastResponse.body}');
        }
      } catch (e) {
        print('Error during broadcasting: $e');
      }



      // } else {
      //   print('Error signing transaction: ${signResponse.body}');
      // }
    } else {
      print('Error creating transaction: ${createResponse.body}');
    }
  }

  // void main() async {
  //   const privateKey = 'c66578a4aac443073050601295b970af2d9fa4643b39baa617f8afa8169e1bf7'; // Replace with your private key
  //   const amount = 7; // Amount in USDT
  //
  //   await sendUSDT(privateKey, amount);
  // }
  //   void main() async {
  //     final TronService tronService = TronService();
  //     bool success = await tronService.sendTrc20(
  //       "TEGAcjUoR9W8mdKqXEWd7KNaWH8sTs8S1s",
  //       "TKSRbKd1K8v62FLLeKeMd19joP1oxCPTjP",
  //       "1",  // Smallest unit test
  //       "TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t", // USDT Contract Address
  //     );
  //     if (success) {
  //       print("USDT sent successfully!");
  //     } else {
  //       print("Failed to send USDT.");
  //     }
  //
  // }
  // void main() async {
  //   String address = "TEGAcjUoR9W8mdKqXEWd7KNaWH8sTs8S1s"; // Replace with your TRON address
  //   final TronService tronService = TronService();
  //   double? balance = await tronService.getTronBalance(address);
  //
  //   if (balance != null) {
  //     print("TRX Balance: $balance");
  //   } else {
  //     print("Failed to fetch balance.");
  //   }
  // }
  void main() async {
    final TronService tronService = TronService();
    double? balance = await tronService.generateWallet();

    if (balance != null) {
      print("TRX Balance: $balance");
    } else {
      print("Failed to fetch balance.");
    }
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
      body:
SingleChildScrollView( child:       Padding(
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
                //onPressed: _confirmWithdraw,
                 //onPressed: main,
                onPressed: main,
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
            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                //onPressed: _confirmWithdraw,
                 //onPressed: main,
                onPressed: main,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "TRN",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
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
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        )
            : Icon(icon, size: 24, color: Colors.grey),
      ),
    );
  }
}
