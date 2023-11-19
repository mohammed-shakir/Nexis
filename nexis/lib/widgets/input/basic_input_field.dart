import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';

class BasicInputField extends BaseInputField {
  final TextEditingController controller;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;

  const BasicInputField({
    Key? key,
    required this.controller,
    this.autovalidateMode,
    this.validator,
  }) : super(key: key);

  @override
  BasicInputFieldState createState() => BasicInputFieldState();
}

class BasicInputFieldState extends BaseInputFieldState<BasicInputField> {
  @override
  Widget build(BuildContext context) {
    return textFormField(
      controller: widget.controller,
      autovalidateMode: widget.autovalidateMode!,
      validator: widget.validator,
      focusBorderColor: Theme.of(context).colorScheme.outline,
    );
  }
}
