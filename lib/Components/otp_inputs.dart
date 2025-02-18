import 'package:flutter/material.dart';

class CustomEditableOTPInput extends StatefulWidget {
  final int length;
  final TextEditingController? controller; // Add a controller parameter
  final ValueChanged<String>? onCompleted;

  const CustomEditableOTPInput({
    Key? key,
    this.length = 6,
    this.controller,
    this.onCompleted,
  }) : super(key: key);

  @override
  _CustomEditableOTPInputState createState() => _CustomEditableOTPInputState();
}

class _CustomEditableOTPInputState extends State<CustomEditableOTPInput> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _controllers = List.generate(widget.length, (_) => TextEditingController());
  }

  @override
  void dispose() {
    // Dispose all controllers and focus nodes
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 50,
          child: TextField(
            autofocus: true,
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            maxLength: 1,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color, // Explicitly set text color
            ),
            onChanged: (value) {
              if (value.length == 1 && index < widget.length - 1) {
                FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
              }
              if (value.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
              }
              // Update the combined OTP in the main controller
              if (widget.controller != null) {
                widget.controller!.text = _controllers.map((e) => e.text).join();
              }
              // Call onCompleted when all fields are filled
              if (_controllers.every((controller) => controller.text.isNotEmpty)) {
                String otp = _controllers.map((e) => e.text).join();
                if (widget.onCompleted != null) {
                  widget.onCompleted!(otp);
                }
              }
            },
            decoration: InputDecoration(
              counterText: "", // Hides the max length counter
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),
        );
      }),
    );
  }
}