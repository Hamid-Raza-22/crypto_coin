import 'package:crypto_coin/Views/AppRoutes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class PolicyDialog extends StatefulWidget {
  const PolicyDialog({Key? key}) : super(key: key);

  @override
  _PolicyDialogState createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<PolicyDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: Text(
        "Terms and Conditions",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      contentPadding: const EdgeInsets.all(16), // Adjust padding for smaller size
      content: SizedBox(
        width: double.maxFinite, // Allow flexible width
        height: 300, // Set a fixed height for the scrollable area
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Last Updated: 10 Dec 2025",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("1. Introduction"),
              const Text(
                "Welcome to C Coin App. By accessing and using our crypto wallet application, you agree to be bound by these Terms and Conditions ('Terms'). If you do not agree, please do not use the application.\n\n"
                    "These Terms govern your use of C Coin App, including all associated features, functionalities, and services provided through the application. By using C Coin App, you acknowledge that you have read, understood, and agreed to these Terms.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("2. Eligibility"),
              const Text(
                "You must be at least 18 years old to use our application. By using this application, you represent and warrant that you meet this eligibility requirement. If you are using the application on behalf of an organization, you confirm that you have the authority to bind that organization to these Terms.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("3. Services"),
              const Text(
                "C Coin App provides a secure platform for managing cryptocurrency transactions, including but not limited to:\n"
                    "- Sending and receiving digital assets.\n"
                    "- Storing cryptocurrencies securely within your wallet.\n"
                    "- Accessing transaction history and monitoring account balances.\n"
                    "- Integrating with blockchain networks for seamless transactions.\n\n"
                    "We do not control or influence the underlying blockchain networks, and we do not provide financial, investment, or legal advice.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("4. Account and Security"),
              const Text(
                "- You are responsible for maintaining the confidentiality of your login credentials, including passwords, private keys, and authentication details.\n"
                    "- We do not store, recover, or have access to your private keys or passwords. If you lose your private key, you may permanently lose access to your assets.\n"
                    "- You must take reasonable measures to protect your device and application from unauthorized access.\n"
                    "- If you detect any unauthorized access or suspicious activities in your account, you must notify us immediately at 'info@cryptocoinworld.net'.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("5. Risks"),
              const Text(
                "- Cryptocurrency transactions are irreversible and subject to market volatility. The value of your digital assets may fluctuate significantly.\n"
                    "- There is a risk of losing your assets due to market crashes, cyber-attacks, technical failures, or human errors.\n"
                    "- C Coin App does not assume responsibility for any loss or damages resulting from unauthorized access, blockchain network failures, or security breaches.\n"
                    "- You acknowledge that investing in cryptocurrencies involves risks, and you should conduct your own research before engaging in transactions.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("6. Fees"),
              const Text(
                "- We may charge fees for certain transactions, such as transfers, conversions, or premium services. These fees will be clearly disclosed within the application before you proceed with any transaction.\n"
                    "- Transaction fees may also apply depending on blockchain network conditions.\n"
                    "- C Coin App reserves the right to modify fees at any time, with prior notice to users.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("7. Prohibited Activities"),
              const Text(
                "You agree not to use C Coin App for any illegal, fraudulent, or prohibited activities, including but not limited to:\n"
                    "- Engaging in fraud, money laundering, or terrorist financing.\n"
                    "- Conducting unauthorized access, hacking, or other malicious activities.\n"
                    "- Violating any applicable laws, regulations, or third-party rights.\n"
                    "- Using the application to distribute malware, engage in phishing, or perform any cyber-related threats.\n\n"
                    "If we detect any suspicious activity, we reserve the right to restrict or terminate your account and report such activities to relevant authorities.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("8. Third-Party Services"),
              const Text(
                "- C Coin App may integrate with third-party services, such as blockchain networks, exchanges, or payment processors.\n"
                    "- We do not control, endorse, or take responsibility for third-party services, and any issues arising from their use must be resolved directly with the respective providers.\n"
                    "- Your use of third-party services is subject to their own terms and conditions, which we encourage you to review.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("9. Limitation of Liability"),
              const Text(
                "To the maximum extent permitted by law, we shall not be held liable for any direct, indirect, incidental, special, or consequential damages arising from:\n"
                    "- Your use of or inability to use the application.\n"
                    "- Loss of funds due to unauthorized access, system failures, or technical errors.\n"
                    "- Changes in cryptocurrency prices leading to financial losses.\n"
                    "- Acts of third-party providers, including blockchain networks or service failures.\n\n"
                    "You acknowledge and agree that C Coin App is provided 'as-is' and 'as available' without any warranties of any kind, either express or implied.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("10. Termination"),
              const Text(
                "- We reserve the right to suspend, restrict, or terminate your access to C Coin App if you violate these Terms or engage in prohibited activities.\n"
                    "- You may terminate your use of C Coin App at any time by ceasing to use the application.\n"
                    "- Termination of your account does not relieve you of any obligations or liabilities incurred before termination.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("11. Changes to Terms"),
              const Text(
                "- We may update these Terms periodically. Any changes will be communicated to you through notifications within the application or via email.\n"
                    "- Continued use of the application after updates to the Terms constitutes acceptance of the new Terms.\n"
                    "- It is your responsibility to review the Terms regularly to stay informed of any changes.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("12. Governing Law"),
              const Text(
                "These Terms shall be governed by and construed in accordance with the laws of [Jurisdiction]. Any disputes arising out of or relating to these Terms shall be resolved in the courts of [Jurisdiction].",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              _buildBoldHeading("13. Contact Information"),
              const Text(
                "For any questions, concerns, or support regarding these Terms, please contact us at info@cryptocoinworld.net.",
                style: TextStyle(fontSize: 14, height: 1.4),
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isChecked = newValue ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isChecked = !_isChecked;
                        });
                      },
                      child: const Text(
                        "I agree to the above Terms and Conditions",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Handle "Deny" button press
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          ),
          child: const Text(
            "Deny",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ),
        ElevatedButton(
          onPressed: _isChecked
              ? () {
            // _requestPermissions();
            Get.offNamed(AppRoutes.signup);
          }
              : null, // Disable the button if checkbox is not checked
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            backgroundColor: _isChecked ? Colors.green : Colors.grey,
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text("Agree", style: TextStyle(color: Colors.white),),
        ),
      ],
    );
  }

  // Helper method to create bold headings
  Widget _buildBoldHeading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    if (await Permission.notification.request().isDenied) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return;
    }
    if (await Permission.location.request().isDenied) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      Get.offNamed('/login');
    }
  }
}