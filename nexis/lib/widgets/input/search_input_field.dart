import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';

class SearchInputField extends BaseInputField {
  final TextEditingController controller;
  const SearchInputField({
    Key? key,
    required this.controller,
  }) : super(key: key, focusBorderColor: const Color(0xFF800020));

  @override
  SearchInputFieldState createState() => SearchInputFieldState();
}

class SearchInputFieldState extends BaseInputFieldState<SearchInputField> {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      textFormField(controller: widget.controller),
      const Positioned(
          right: 0,
          child: Icon(
            Icons.visibility,
            color: Colors.grey,
          )),
    ]);
  }
}
