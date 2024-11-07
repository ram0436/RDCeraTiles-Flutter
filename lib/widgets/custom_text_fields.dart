import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for input formatters

class CustomTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>?
      inputFormatters; // Make inputFormatters optional

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    required this.controller,
    this.validator,
    this.onChanged,
    this.inputFormatters, // Initialize inputFormatters
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
          hintStyle: const TextStyle(
            color: Colors.black45,
            fontSize: 16,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        inputFormatters: inputFormatters, // Use inputFormatters if provided
      ),
    );
  }
}
