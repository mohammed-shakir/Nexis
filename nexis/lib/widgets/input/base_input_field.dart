import 'package:flutter/material.dart';

abstract class BaseInputField extends StatefulWidget {
  const BaseInputField({
    Key? key,
  }) : super(key: key);

  InputDecoration fieldDecoration(BuildContext context,
      [EdgeInsetsGeometry? contentPadding,
      Color? fillColor,
      String? hint,
      Color? focusBorderColor,
      Color? hoverColor,
      TextStyle? hintStyle,
      int? errorMaxLines]) {
    return InputDecoration(
        hoverColor: hoverColor,
        border: buildBorder(context),
        focusedBorder: buildBorder(context, focusBorderColor),
        filled: true,
        fillColor: fillColor ?? Colors.blueGrey[750],
        hintText: hint,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.labelSmall,
        errorMaxLines: errorMaxLines,
        contentPadding: contentPadding ??
            const EdgeInsets.only(
                right: 10.0, left: 10.0, top: 10.0, bottom: 10.0));
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
    String? Function(String?)? validator,
    void Function()? onTap,
    void Function(String)? onChanged,
    TextStyle? style,
    TextStyle? hintStyle,
    bool readOnly = false,
    bool obscureText = false,
    Color cursorColor = Colors.white,
    Color? fillColor,
    Color focusBorderColor = const Color(0xFF800020),
    Color hoverColor = Colors.transparent,
    double cursorHeight = 20.0,
    double cursorWidth = 1.2,
    int minLines = 1,
    int maxLines = 1,
    int errorMaxLines = 3,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    EdgeInsetsGeometry? contentPadding,
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
      onChanged: onChanged,
      decoration: widget.fieldDecoration(context, contentPadding, fillColor,
          hint, focusBorderColor, hoverColor, hintStyle, errorMaxLines),
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
