import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';

class BasicInputField extends BaseInputField {
  final TextEditingController controller;
  const BasicInputField({
    Key? key,
    required this.controller,
  }) : super(key: key, focusBorderColor: const Color(0xFF800020));

  @override
  BasicInputFieldState createState() => BasicInputFieldState();
}

class BasicInputFieldState extends BaseInputFieldState<BasicInputField> {
  @override
  Widget build(BuildContext context) {
    return textFormField(controller: widget.controller);
  }
}
