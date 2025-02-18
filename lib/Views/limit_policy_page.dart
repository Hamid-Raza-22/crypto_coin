import 'package:flutter/material.dart';

class LimitsPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

      appBar: AppBar(
        title: Text('Limits Policy'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Limits Policy',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'This Limits Policy ("Policy") outlines the transaction limits applicable to users of C Coin App. These limits are established to enhance security, comply with regulatory requirements, and protect users from unauthorized transactions. By using C Coin App, you agree to adhere to these limits as outlined in this Policy.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            buildSectionHeader('1. Types of Limits'),
            buildSectionBody(
              'C Coin App may impose various limits on transactions, which include but are not limited to:\n'
                  '- Deposit Limits: Maximum and minimum amounts that can be deposited into your wallet.\n'
                  '- Withdrawal Limits: Restrictions on the amount that can be withdrawn within a specified period.\n'
                  '- Transaction Limits: Limits on the number and value of transactions that can be conducted daily, weekly, or monthly.\n'
                  '- Spending Limits: Caps on purchases and transfers made using the application.\n'
                  '- Transfer Limits: Restrictions on the number of transactions to other users or external wallets.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('2. Default and Custom Limits'),
            buildSectionBody(
              '- A minimum transaction amount of \$20 is required for each transaction.\n'
                  '- Each transaction is subject to a \$2 gas fee to support the sustainability and longevity of the application.\n'
                  '- Default limits may be applied to all accounts based on verification status and security requirements.\n'
                  '- Users may request adjustments to their limits by undergoing additional verification procedures.\n'
                  '- C Coin App reserves the right to approve or deny limit adjustment requests at its sole discretion.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('3. Compliance and Security'),
            buildSectionBody(
              '- Limits are enforced to comply with financial regulations and anti-money laundering (AML) policies.\n'
                  '- Transaction monitoring may be conducted to detect and prevent fraudulent or suspicious activities.\n'
                  '- Users attempting to bypass limits through fraudulent means may have their accounts restricted or terminated.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('4. Blockchain Network'),
            buildSectionBody(
              '- C Coin App operates on the Tron (TRC20) blockchain, ensuring fast and secure transactions.\n'
                  '- All transactions, including deposits and withdrawals, adhere to TRC20 network standards.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('5. Modifications to Limits'),
            buildSectionBody(
              '- C Coin App reserves the right to modify limits at any time without prior notice for security, compliance, or operational reasons.\n'
                  '- Users will be notified of significant changes to limits through the application or email communication.',
            ),
            SizedBox(height: 20),
            buildSectionHeader('6. Contact Information'),
            buildSectionBody(
              'For any questions or requests regarding transaction limits, please contact our support team at:\n'
                  'info@cryptocoinworld.net',
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