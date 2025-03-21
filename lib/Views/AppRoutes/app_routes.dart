// app_routes.dart
import 'package:crypto_coin/Views/home/wallet_screen.dart';
import 'package:crypto_coin/Views/singup_screen.dart';
import 'package:crypto_coin/Views/splesh_screen.dart';
import 'package:crypto_coin/Views/step_one_email_screen.dart';
import 'package:crypto_coin/Views/successfully_create_accont.dart';
import 'package:crypto_coin/Views/three_step_lock_screen.dart';
import 'package:get/get.dart';
import '../PolicyDBox.dart';
import '../account_activation_screen.dart';
import '../confirm_email_screen.dart';
import '../create_password_screen.dart';
import '../email_code_screen.dart';
import '../home/WalletComponents/wallet_screen_two.dart';
import '../main_screen.dart';
import '../login_screen.dart';
import '../verification_success_screen.dart';

class AppRoutes {
  static const String splashScreen = '/splashScreen';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String threeStepLockScreen = '/ThreeStepLockScreen';
  static const String stepOneEmailScreen = '/StepOneEmailScreen';
  static const String confirmEmailScreen = '/ConfirmEmailScreen';
  static const String emailCodeScreen = '/EmailCodeScreen';
  static const String verificationSuccessScreen = '/VerificationSuccessScreen';
  static const String createPasswordScreen = '/CreatePasswordScreen';
  static const String successfullyCreateAccount = '/SuccessfullyCreateAccount';
   static const String homeScreen = '/HomeScreen';
  //static const String homepage = '/MyHomePage';
  static const String walletScreen = '/WalletScreen';
  static const String walletScreenTwo = '/WalletScreenTwo';
  static const String policyDialog = '/PolicyDialog';

  static const String walletDepositScreen = '/WalletDepositScreen';
  static const String walletWithdrawConfirmScreen = '/WalletWithdrawConfirmScreen';
  static const String walletWithdrawScreen = '/WalletWithdrawScreen';
  static const String walletMainPage = '/WalletMainPage';
  static const String walletPortfolioPage = '/WalletPortfolioPage';
  static const String walletTransactionHistoryPage = '/WalletTransactionHistoryPage';
  static const String walletTransactionPage = '/WalletTransactionPage';
  static const String walletTransactionSuccessPage = '/WalletTransactionSuccessPage';
  static const String walletTransactionDetailPage = '/WalletTransactionDetailPage';

  static const String channelScreen = '/ChannelScreen';
  // static const String homeScreen = '/HomeScreen';
  static const String serviceScreen = '/ServiceScreen';
  static const String teamScreen = '/TeamScreen';

  static const String accountActivationScreen = '/AccountActivationScreen';
  static final routes = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: policyDialog, page: ()=> const PolicyDialog()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () =>  SignupScreen()),
    GetPage(name: threeStepLockScreen, page: () =>  ThreeStepLockScreen()),
    GetPage(name: stepOneEmailScreen, page: () => const StepOneEmailScreen()),
    GetPage(name: confirmEmailScreen, page: () => ConfirmEmailScreen()),
    GetPage(name: emailCodeScreen, page: () => const EmailCodeScreen()),
    GetPage(name: verificationSuccessScreen, page: () => const VerificationSuccessScreen()),
    GetPage(name: createPasswordScreen, page: () => const CreatePasswordScreen()),
    GetPage(name: successfullyCreateAccount, page: () => const SuccessfullyCreateAccount()),
     GetPage(name: homeScreen, page: () =>  MainScreen()),
    // GetPage(name: homepage, page: () =>  const WalletScreen()),
    GetPage(name: walletScreen, page: () =>   WalletScreen()),
    GetPage(name: walletScreenTwo, page: () =>   WalletScreenTwo()),
    GetPage(name: accountActivationScreen, page: () =>  AccountActivationScreen()),


  ];
}