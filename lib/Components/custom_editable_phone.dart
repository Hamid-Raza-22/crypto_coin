
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomEditablePhoneNumberOption extends StatelessWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const CustomEditablePhoneNumberOption({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    PhoneNumber number = PhoneNumber(isoCode: 'PK');  // Default country code (can be changed)

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(3, 5),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InternationalPhoneNumberInput(
            onInputChanged: (PhoneNumber value) {
              onChanged(value.phoneNumber ?? '');  // Pass the updated phone number
            },
            initialValue: number,
            inputDecoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
            ),
            selectorConfig: SelectorConfig(
              selectorType: PhoneInputSelectorType.DIALOG,
            ),
            hintText: 'Enter phone number',
          ),
        ],
      ),
    );
  }
}
