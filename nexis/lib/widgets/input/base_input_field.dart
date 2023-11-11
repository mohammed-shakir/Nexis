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
    TextEditingController? controller,
    FocusNode? focusNode,
    void Function(String)? onFieldSubmitted,
    TextStyle? style,
    bool readOnly = false,
    bool obscureText = false,
    Color cursorColor = Colors.white,
    double cursorHeight = 20.0,
    double cursorWidth = 1.2,
    int minLines = 1,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    String? Function(String?)? validator,
    void Function()? onTap,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      style: style ?? Theme.of(context).textTheme.displayMedium,
      readOnly: readOnly,
      obscureText: obscureText,
      cursorColor: cursorColor,
      cursorHeight: cursorHeight,
      cursorWidth: cursorWidth,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      autovalidateMode: autovalidateMode,
      validator: validator,
      onTap: onTap,
      decoration: widget.fieldDecoration(context),
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
