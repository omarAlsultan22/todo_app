import 'package:flutter/material.dart';


class DefaultFormField extends StatelessWidget {
  TextEditingController controller;
  TextInputType type;
  String? Function(String?)? validator;
  IconData prefix;
  String label;
  VoidCallback? onTap;

  DefaultFormField({
    required this.controller,
    required this.type,
    required this.prefix,
    required this.label,
    this.validator,
    this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validator,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
      ),
    );
  }
}
