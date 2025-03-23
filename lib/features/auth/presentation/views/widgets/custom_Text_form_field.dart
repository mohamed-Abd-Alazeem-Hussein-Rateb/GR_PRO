import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
   CustomTextFormField({super.key, this.suffixIcon, required this.validator, required this.lableText, required this.prefixIcon, required this.obscureText, required this.controller});

    String? Function(String?)? validator; // ✅ تعديل النوع ليسمح بـ null
    String lableText;
    Widget prefixIcon;
    bool obscureText;
    TextEditingController controller;
    Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator, // ✅ الآن يقبل إرجاع null بشكل صحيح
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: lableText,
        prefixIcon: prefixIcon,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
