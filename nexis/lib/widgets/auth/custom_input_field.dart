import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool? obscureText;
  final String? hint;
  final void Function()? onTap;
  final TextEditingController? controller;
  final bool? readOnly;
  final void Function(String)? onSubmitted;

  const CustomTextField({
    this.obscureText, 
    this.hint, 
    this.onTap, 
    this.controller, 
    this.readOnly, 
    this.onSubmitted, 
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly ?? false,
      obscureText: obscureText ?? false,
      cursorColor: Colors.white,
      cursorHeight: 22,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: buildBoarder(),
        focusedBorder: buildBoarder(const Color(0xFF800020)),
        filled: true,
        fillColor: Colors.blueGrey[750],
      ),
      style: const TextStyle(color: Colors.white),
      onSubmitted: onSubmitted,
    );
  }

  OutlineInputBorder buildBoarder([color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: color ?? const Color(0xFF171c2a),
      ),
    );
  }
}