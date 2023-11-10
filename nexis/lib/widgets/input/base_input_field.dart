import 'package:flutter/material.dart';

abstract class BaseInputField extends StatefulWidget {
  final Color? focusBorderColor;
  const BaseInputField({
    Key? key,
    this.focusBorderColor,
  }) : super(key: key);

  InputDecoration fieldDecoration(BuildContext context) {
    return InputDecoration(
        hoverColor: Colors.transparent,
        border: buildBorder(context),
        focusedBorder: buildBorder(context, focusBorderColor),
        filled: true,
        fillColor: Colors.blueGrey[750],
        hintStyle: Theme.of(context).textTheme.labelSmall,
        contentPadding: const EdgeInsets.only(
            right: 10.0, left: 10.0, top: 10, bottom: 10));
  }

  OutlineInputBorder buildBorder([context, color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color ?? Theme.of(context).colorScheme.outline,
      ),
    );
  }

  @override
  State<BaseInputField> createState();
}

abstract class BaseInputFieldState<T extends BaseInputField> extends State<T> {
  TextFormField textFormField({
    bool obscureText = false,
  }) {
    return TextFormField(
      style: Theme.of(context).textTheme.displayMedium,
      cursorColor: Colors.white,
      cursorHeight: 20.0,
      cursorWidth: 1.2,
      decoration: widget.fieldDecoration(context),
      obscureText: obscureText,
    );
  }

  Color setColor(bool hover) {
    if (hover) {
      return Colors.white;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context);
}
