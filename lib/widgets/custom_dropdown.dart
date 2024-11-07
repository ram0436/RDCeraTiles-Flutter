import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String hintText;
  final String labelText;
  final String? value; // Add value property
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomDropdown({
    Key? key,
    required this.hintText,
    required this.labelText,
    this.value, // Accept value
    required this.items,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value, // Set the current value
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
      
    );
  }
}
