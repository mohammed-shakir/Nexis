import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';

class PasswordInputField extends BaseInputField {
  final TextEditingController controller;
  const PasswordInputField({
    Key? key,
    required this.controller,
  }) : super(key: key, focusBorderColor: const Color(0xFF800020));

  @override
  PasswordInputFieldState createState() => PasswordInputFieldState();
}

class PasswordInputFieldState extends BaseInputFieldState<PasswordInputField> {
  late bool obscureTextIconHover = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      textFormField(controller: widget.controller, obscureText: obscureText),
      Positioned(
          right: 0,
          child: MouseRegion(
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
              padding: const EdgeInsets.fromLTRB(5.0, 8.5, 5.0, 0.0),
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
          )),
    ]);
  }
}
