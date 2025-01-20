import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'firebase_remote_config.dart';



Future<bool> sendOtpEmailHttp(String email) async {
  await Config.fetchLatestConfig();
  final url = Uri.parse(Config.postApiUrlSentOtpEmailGoogleCloud);

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('OTP sent successfully: ${responseData['message']}');
      return true;
    } else {
      if (kDebugMode) {
        print('Error sending OTP: ${response.statusCode} - ${response.body}');
      }
      return false;
    }
  } catch (e) {
    print('Error sending OTP: $e');
    return false;
  }
}


Future<bool> verifyOtpEmailHttp(String email, String otp) async {
  await Config.fetchLatestConfig();
  final url = Uri.parse(Config.postApiUrlVerifyOtpEmailGoogleCloud);
  // final url = Uri.parse('https://us-central1-crypto-coin-f8437.cloudfunctions.net/verifyOtp');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('OTP verification successful: ${responseData['message']}');
      return true; // Return true if the OTP verification is successful
    } else {
      if (kDebugMode) {
        print('Error verifying OTP: ${response.statusCode} - ${response.body}');
      }
      return false; // Return false if the OTP verification fails
    }
  } catch (e) {
    print('Error verifying OTP: $e');
    return false; // Return false if there is an exception
  }
}
