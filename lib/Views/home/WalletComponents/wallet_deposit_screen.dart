import 'package:crypto_coin/Utilities/global_variables.dart';
import 'package:crypto_coin/Views/home/WalletComponents/wallet_withdraw_confirm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WalletDepositScreen extends StatelessWidget {
  const WalletDepositScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme

      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [     Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WalletDepositScreen()),
                      );
                      // Add deposit functionality
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Deposit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WithdrawPage()),
                      );                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Withdraw",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
              const SizedBox(height: 10),

              _buildQRSection(context),
              const SizedBox(height: 20),
              _buildDepositDetailsCard(context),
              const SizedBox(height: 20),
               _buildDepositInfoSection(context),
               const SizedBox(height: 20),
              // _buildDisclaimerSection(context),
              const SizedBox(height: 20),
              _buildSaveAndShareButton(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Respects theme
      title: const Text('Deposit USDT'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.question_mark),
          onPressed: () {},
          tooltip: 'Help',
        ),
        // IconButton(
        //   icon: const Icon(Icons.qr_code_scanner),
        //   onPressed: () {},
        //   tooltip: 'Scan QR Code',
        // ),
      ],
    );
  }

  Widget _buildQRSection(BuildContext context) {
    return Center(
      child: QrImageView(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white // Light mode: white background
            : Colors.grey[200]!, // Dark mode: light gray background
        data: publicKey!,
        version: QrVersions.auto,
        size: 200.0,
        gapless: false,
        embeddedImage: const AssetImage(logo),
        embeddedImageStyle: const QrEmbeddedImageStyle(
          size: Size(20, 20),
        ),
      ),
    );
  }
  Widget _buildDepositDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabelText('Network', context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tron (TRC20)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // IconButton(
                //   icon: const Icon(Icons.swap_horiz),
                //   onPressed: () {},
                //   tooltip: 'Switch Network',
                // ),
              ],
            ),
          //  _buildLabelText('* Contract Information ***jLjt', context),
            const SizedBox(height: 10),
            _buildLabelText('Deposit Address', context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    publicKey!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    // Text to be copied
                    final textToCopy = publicKey!;
                    // Copy text to clipboard
                    Clipboard.setData(ClipboardData(text: textToCopy));
                  },
                  tooltip: 'Copy Address',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelText(String text, BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
    );
  }

  Widget _buildDepositInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Deposit to', 'Spot Wallet', context),
        _buildInfoRow('Minimum deposit', '>0.01 USDT', context),
        _buildInfoRow('Credited (Trading enabled)', '1 Confirmation(s)', context),
        _buildInfoRow('Unlocked (Withdrawal enabled)', '1 Confirmation(s)', context),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Widget _buildDisclaimerSection(BuildContext context) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       _buildDisclaimerText('* Do not transact with Sanctioned Entities. Learn more', context),
  //       _buildDisclaimerText('* Don’t send NFTs to this address.', context),
  //       _buildDisclaimerText(
  //         'Deposit via smart contracts are not supported with the exception of ETH via ERC20. Arbitrum & Optimism network or BNB via BSC network.',
  //         context,
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildDisclaimerText(String text, BuildContext context) {
  //   return Text(
  //     text,
  //     style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
  //   );
  // }

  Widget _buildSaveAndShareButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: const Text('Save and Share Address'),
    );
  }
}