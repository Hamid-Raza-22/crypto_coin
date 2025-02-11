import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Effective Date: [2025 All right Reserved]\n\nWelcome to C App! Your privacy is important to us. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our application. By accessing or using C App, you agree to this Privacy Policy. If you do not agree, please do not use the app.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            buildSectionHeader('1. Information We Collect'),
            buildSectionBody(
              'a. Personal Information\nWhen you register or use C App, we may collect personal information, including but not limited to:\n- Full name\n- Email address\n- Phone number\n- Identification documents (e.g., KYC verification)\n- Payment details (e.g., bank account, credit/debit card, cryptocurrency wallet addresses)\n\nb. Non-Personal Information\nWe may also collect non-personal data such as:\n- Device information (e.g., model, operating system, and unique device identifiers)\n- IP address and geolocation data\n- App usage data (e.g., features used, time spent, interactions)\n\nc. Cookies and Tracking\nWe may use cookies and other tracking technologies to enhance your experience and collect analytics about your usage.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('2. How We Use Your Information'),
            buildSectionBody(
              'We use the information we collect to:\n- Provide, operate, and maintain C App\n- Verify your identity and prevent fraud\n- Process transactions and facilitate deposits/withdrawals\n- Send important updates, notifications, and promotional materials\n- Analyze usage trends and improve the app’s functionality\n- Comply with legal and regulatory requirements',
            ),
            SizedBox(height: 20),
            buildSectionHeader('3. How We Share Your Information'),
            buildSectionBody(
              'We do not sell your personal information. However, we may share your information in the following scenarios:\n- With Service Providers: We may share information with third-party vendors who assist in providing services such as payment processing, identity verification, and app analytics.\n- Legal Obligations: We may disclose your information if required by law, regulation, or court order.\n- Business Transfers: In the event of a merger, acquisition, or sale of assets, your information may be transferred to the new entity.\n- With Your Consent: We may share information with your explicit consent.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('4. How We Protect Your Information'),
            buildSectionBody(
              'We implement appropriate technical and organizational measures to protect your information, including:\n- Encryption for data in transit and at rest\n- Two-factor authentication (2FA) for account access\n- Regular security audits and vulnerability assessments\n\nWhile we strive to safeguard your information, no system is 100% secure, and we cannot guarantee the absolute security of your data.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('5. Your Rights and Choices'),
            buildSectionBody(
              'a. Access and Update Information\nYou can access and update your personal information directly through the app or by contacting our support team.\n\nb. Opt-Out\nYou may opt out of receiving promotional emails by following the unsubscribe link in our communications. Note that you cannot opt out of essential notifications related to account security or transactions.\n\nc. Delete Account\nIf you wish to delete your account and associated data, please contact us. Some information may be retained to comply with legal obligations.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('6. Third-Party Services'),
            buildSectionBody(
              'C App may integrate with third-party services, such as blockchain networks or payment providers. We are not responsible for the privacy practices of these third parties, and we encourage you to review their privacy policies.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('7. Children’s Privacy'),
            buildSectionBody(
              'C App is not intended for individuals under the age of 18. We do not knowingly collect information from children. If we discover that we have inadvertently collected such data, we will delete it promptly.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('8. Changes to This Privacy Policy'),
            buildSectionBody(
              'We may update this Privacy Policy from time to time. When we do, we will revise the "Effective Date" at the top of this page and notify you of significant changes. Please review the policy periodically to stay informed.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('9. Contact Us'),
            buildSectionBody(
              'If you have any questions or concerns about this Privacy Policy or how we handle your information, please contact us at:\n\nC App Support Team\n- Email: support@capp.com\n- Phone: +[Insert Phone Number]\n\nThank you for trusting C App. Your privacy is our priority.',
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget buildSectionBody(String content) {
    return Text(
      content,
      style: TextStyle(fontSize: 16, height: 1.5),
    );
  }
}
