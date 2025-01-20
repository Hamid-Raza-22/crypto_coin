import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class Config {
  static late FirebaseRemoteConfig remoteConfig;

  static Future<void> initialize() async {
    remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: Duration(seconds: 1),
      // Set to 1 minute for development; change to a larger interval for production
      minimumFetchInterval: Duration(seconds: 1),
    ));
    await fetchLatestConfig(); // Fetch and activate immediately
  }

  static Future<void> fetchLatestConfig() async {
    try {
      bool updated = await remoteConfig.fetchAndActivate();
      if (updated) {
        if (kDebugMode) {
          print('Remote config updated');
        }
      } else {
        if (kDebugMode) {
          print('No changes in remote config');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch remote config: $e');
      }
    }
  }

// Static configuration parameters for GET API URLs
 // static String get getApiUrlLogin => remoteConfig.getString('LoginGetUrl');


// Static configuration parameters for POST API URLs with postApiUrl prefix
  static String get postApiUrlSentOtpEmailGoogleCloud => remoteConfig.getString('sentOtpEmail_Google_Cloud');
  static String get postApiUrlVerifyOtpEmailGoogleCloud => remoteConfig.getString('verify_otp_url');
  static String get postApiUrlSentOtpEmailFirebase => remoteConfig.getString('SentOtpEmail_firebase_Cloud');


}
