import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';

class PasswordInputField extends BaseInputField {
  final TextEditingController controller;
  final AutovalidateMode autovalidateMode;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  const PasswordInputField({
    Key? key,
    required this.controller,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  PasswordInputFieldState createState() => PasswordInputFieldState();
}

class PasswordInputFieldState extends BaseInputFieldState<PasswordInputField> {
  late bool obscureTextIconHover = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        textFormField(
            controller: widget.controller,
            autovalidateMode: widget.autovalidateMode,
            validator: widget.validator,
            obscureText: obscureText,
            contentPadding: const EdgeInsets.only(
                right: 40.0, left: 10.0, top: 10.0, bottom: 10.0),
            focusBorderColor: Theme.of(context).colorScheme.secondary,
            onFieldSubmitted: widget.onFieldSubmitted),
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: mouseRegionObscureText(),
        ),
      ],
    );
  }

  Widget mouseRegionObscureText() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          obscureTextIconHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          obscureTextIconHover = false;
        });
      },
      child: IconButton(
        constraints: const BoxConstraints(maxWidth: 40.0),
        iconSize: 30.0,
        onPressed: () {
          setState(() {
            obscureText = !obscureText;
          });
        },
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        icon: Icon(
          obscureText ? Icons.visibility_off : Icons.visibility,
          color: setColor(obscureTextIconHover),
        ),
      ),
    );
  }
}
