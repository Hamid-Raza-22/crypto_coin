import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';



Future<void> launchPayFastPayment() async {
  final Uri payFastUrl = Uri.parse(
    'https://www.payfast.co.za/eng/process?merchant_id=25297955&merchant_key=lcmxs4rtfxvmf'
        '&amount=100.00&item_name=${Uri.encodeComponent('Payment')}'  // Encode special characters
        '&return_url=${Uri.encodeFull('https://yourapp.com/success')}'
        '&cancel_url=${Uri.encodeFull('https://yourapp.com/cancel')}',
  );

  debugPrint('Attempting to launch $payFastUrl');

  if (await canLaunchUrl(payFastUrl)) {
    await launchUrl(payFastUrl, mode: LaunchMode.externalApplication);  // Ensure external browser usage
  } else {
    debugPrint('Could not launch $payFastUrl');
  }
}


Future<void> showPaymentDetailsBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Card Number',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'CVV',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Expiry Date',
              ),
              keyboardType: TextInputType.datetime,
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.pop(context);
                launchPayFastPayment();
              },
            ),
          ],
        ),
      );
    },
  );
}
