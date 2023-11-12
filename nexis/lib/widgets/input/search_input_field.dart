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
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        textFormField(
          controller: widget.controller,
          contentPadding: const EdgeInsets.only(
              right: 35.0, left: 10.0, top: 10.0, bottom: 10.0),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: Icon(
            Icons.search,
            size: 30.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
