import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:base58check/base58check.dart';

class WalletService {
  /// Generate BEP20 Wallet (Binance Smart Chain)
  /// BEP20 uses the same address format as Ethereum but on the Binance Smart Chain.
  Map<String, String> generateBep20Wallet() {
    final rng = Random.secure();
    EthPrivateKey privateKey = EthPrivateKey.createRandom(rng);

    String privateHex = bytesToHex(privateKey.privateKey);
    String address = privateKey.address.hexEip55;

    return {
      "privateKey": privateHex,
      "address": address,
    };
  }

  /// Generate Tron Wallet (TRC20)
  Map<String, String> generateTronWallet() {
    final rng = Random.secure();

    // Generate a secure random private key (32 bytes)
    Uint8List privateKeyBytes = Uint8List.fromList(List.generate(32, (_) => rng.nextInt(256)));

    // Convert private key to hex string
    String privateKeyHex = bytesToHex(privateKeyBytes);

    // Convert private key to BigInt for public key generation
    EthPrivateKey privateKey = EthPrivateKey.fromHex(privateKeyHex);
    Uint8List publicKeyBytes = privateKey.encodedPublicKey;

    // Derive address by hashing public key (remove first byte to get 64-byte key)
    Uint8List addressBytes = keccak256(publicKeyBytes.sublist(1)).sublist(12);

    // Tron mainnet address version (0x41)
    int tronVersionByte = 0x41;

    // Create Base58CheckPayload with version and address bytes
    final payload = Base58CheckPayload(tronVersionByte, addressBytes);

    // Encode address with Base58Check
    String tronAddress = Base58CheckCodec.bitcoin().encode(payload);

    return {
      "privateKey": privateKeyHex,
      "address": tronAddress,
    };
  }

  /// Convert Uint8List to Hexadecimal string
  String bytesToHex(Uint8List bytes) {
    return hex.encode(bytes);
  }

  /// Save Wallet Data to Firebase
  Future<void> saveWalletToFirebase(String email, String walletType, Map<String, dynamic> walletData) async {
    final userDoc = FirebaseFirestore.instance.collection('wallets').doc(email);
    await userDoc.set({
      walletType: walletData
    }, SetOptions(merge: true));
  }
}
