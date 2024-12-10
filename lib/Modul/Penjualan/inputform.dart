import 'package:bonjour/data.dart';
import 'package:flutter/material.dart';

Widget buildInputField({
  required String label,
  required TextEditingController controller,
  required String hintText,
  TextInputType inputType = TextInputType.text,
  String? Function(String?)? validator, // Menambahkan parameter validator
}) {
  return TextFormField(
    controller: controller,
    keyboardType: inputType,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.blue),
      ),
    ),
    validator: validator, // Menggunakan validator yang diberikan
  );
}

Widget buildNumericField({
  required String label,
  required TextEditingController controller,
  required String hintText,
  String? Function(String?)? validator, // Menambahkan parameter validator
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      border: OutlineInputBorder(),
      filled: true,
      fillColor: Colors.grey.shade100,
      enabledBorder: OutlineInputBorder(),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
    ),
    validator: validator, // Menggunakan validator yang diberikan
  );
}
