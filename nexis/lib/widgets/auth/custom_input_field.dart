import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool? obscureText;
  final String? hint;
  final void Function()? onTap;
  final TextEditingController? controller;
  final bool? readOnly;
  final void Function(String)? onSubmitted;
  final Widget? suffixIcon;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    this.obscureText, 
    this.hint, 
    this.onTap, 
    this.controller, 
    this.readOnly, 
    this.onSubmitted, 
    this.suffixIcon,
    this.autovalidateMode,
    this.validator,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly ?? false,
      obscureText: obscureText ?? false,
      cursorColor: Colors.white,
      cursorHeight: 22,
      onTap: onTap,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: buildBorder(Theme.of(context).colorScheme.outline, context),
        focusedBorder: buildBorder(Theme.of(context).colorScheme.secondary, context),
        filled: true,
        fillColor: Colors.blueGrey[750],
      ),
      style: const TextStyle(color: Colors.white),
      onFieldSubmitted: onSubmitted,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      validator: validator,
    );
  }

  OutlineInputBorder buildBorder([color, context]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(
        color: color ?? Theme.of(context).colorScheme.outline,
      ),
    );
  }
}