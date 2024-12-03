import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../Services/PayFast/payfast.dart';
import '../../Utilities/global_variables.dart';
import 'custom_button.dart';

void showStripeStyleBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return PaymentForm();
    },
  );
}

class PaymentForm extends StatefulWidget {
  @override
  _StripePaymentFormState createState() => _StripePaymentFormState();
}

class _StripePaymentFormState extends State<PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, // Adjust for keyboard
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Add Card Details",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              buildTextField(
                controller: _cardNumberController,
                label: "Card Number",
                hint: "1234 5678 9012 3456",
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, CardNumberFormatter()],
              ),
              Row(
                children: [
                  Expanded(
                    child: buildTextField(
                      controller: _expiryDateController,
                      label: "Expiry Date",
                      hint: "MM/YY",
                      icon: Icons.calendar_today,
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [ExpiryDateFormatter()],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: buildTextField(
                      controller: _cvvController,
                      label: "CVV",
                      hint: "***",
                      icon: Icons.lock,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              CustomButton(
                top: MediaQuery.of(context).size.height * 0.8,
                left: MediaQuery.of(context).size.width * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                height: 55,
                buttonText: _isProcessing ? 'Processing...' : 'SAVE',
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                gradientColors: const [buttonColorGreen, buttonColorGreen],
                onTap: () {
                  if (!_isProcessing && _formKey.currentState!.validate()) {
                    setState(() {
                      _isProcessing = true;
                    });
                    Future.delayed(const Duration(seconds: 2), () async {
                      setState(() {
                        _isProcessing = false;
                      });
                      await launchPayFastPayment();
                    });
                  }
                },
                borderRadius: 15.0,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey[600]),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey[600]),
            onPressed: () {
              setState(() {
                controller.clear();
              });
            },
          )
              : null,
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (label == "Card Number" && !isValidCardNumber(value)) {
            return "Invalid card number";
          }
          if (label == "CVV" && value.length != 3) {
            return "CVV must be 3 digits";
          }
          if (label == "Expiry Date" && !RegExp(r'(0[1-9]|1[0-2])\/\d{2}').hasMatch(value)) {
            return "Invalid expiry date";
          }
          return null;
        },
      ),
    );
  }

  bool isValidCardNumber(String input) {
    String cardNumber = input.replaceAll(RegExp(r'\s+'), ''); // Remove spaces
    if (cardNumber.length != 16) {
      return false;
    }
    int sum = 0;
    bool alternate = false;
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      sum += digit;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }
}

// Formatter for card number input
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String numbers = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (numbers.length > 16) numbers = numbers.substring(0, 16);
    String formatted = '';
    for (int i = 0; i < numbers.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += numbers[i];
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formatter for expiry date input
class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String numbers = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (numbers.length > 4) numbers = numbers.substring(0, 4);
    String formatted = '';
    if (numbers.length > 2) {
      formatted = '${numbers.substring(0, 2)}/${numbers.substring(2)}';
    } else {
      formatted = numbers;
    }
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
