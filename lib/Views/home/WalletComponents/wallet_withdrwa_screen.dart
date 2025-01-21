import 'package:flutter/material.dart';

class WithdrawScreen extends StatelessWidget {
  final double withdrawalAmount;
  final double availableBalance;

  WithdrawScreen({
    required this.withdrawalAmount,
    required this.availableBalance,
  });

  @override
  Widget build(BuildContext context) {
    double transactionFee = withdrawalAmount * 0.02;
    double totalWithdrawalAmount = withdrawalAmount + transactionFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Withdraw',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {
              // Help action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Text(
                    'Total Amount',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${totalWithdrawalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Available Balance',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  _buildRowQuantity('Quantity', '${availableBalance.toStringAsFixed(2)} USD'),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildCard(
              child: Column(
                children: [
                  _buildRow('Bank Account', 'monobank XXXX5555'),
                  Divider(),
                  _buildRow('Withdrawal Amount', '\$${withdrawalAmount.toStringAsFixed(2)}'),
                  Divider(),
                  _buildRow('Transaction Fee (2%)', '\$${transactionFee.toStringAsFixed(2)}'),
                  Divider(),
                  _buildRow('Total Withdrawal Amount', '\$${totalWithdrawalAmount.toStringAsFixed(2)}'),
                ],
              ),
            ),
            Spacer(),
            Divider(),
            ElevatedButton(
              onPressed: () {
                // Confirm withdrawal action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: child,
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildRowQuantity(String label, String value) {
    List<String> valueParts = value.split(' '); // Amount aur currency alag karne ke liye
    String amount = valueParts[0]; // Amount part
    String currency = valueParts.length > 1 ? valueParts.sublist(1).join(' ') : ''; // Currency part

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              amount,  // Sirf amount bold hoga
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              currency, // Currency ko alag rakha gya hai
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ],
    );
  }
}
