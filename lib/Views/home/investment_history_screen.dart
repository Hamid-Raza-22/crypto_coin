import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InvestmentHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      'type': 'Deposit',
      'amount': 100.0,
      'icon': Icons.account_balance_wallet,
      'color': Colors.green
    },
    {
      'type': 'Withdrawal',
      'amount': 50.0,
      'icon': Icons.outbox,
      'color': Colors.red
    },
    {
      'type': 'Referral Reward (Level 1)',
      'amount': 10.0,
      'icon': FontAwesomeIcons.userFriends,
      'color': Colors.orange
    },
    {
      'type': 'Daily Earning',
      'amount': 5.0,
      'icon': Icons.monetization_on,
      'color': Colors.blue
    },
    {
      'type': 'Referral Reward (Level 2)',
      'amount': 7.5,
      'icon': FontAwesomeIcons.userFriends,
      'color': Colors.orange
    },
    {
      'type': 'Referral Reward (Level 3)',
      'amount': 3.0,
      'icon': FontAwesomeIcons.userFriends,
      'color': Colors.orange
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Transaction History'),
        ),
        body: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: transaction['color'],
                  child: Icon(
                    transaction['icon'],
                    color: Colors.white,
                  ),
                ),
                title: Text(transaction['type']),
                subtitle: Text('Amount: \$${transaction['amount']}'),
              );
            },
        ),
        );
  }
}