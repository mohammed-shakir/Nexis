import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';

class SearchInputField extends BaseInputField {
  final TextEditingController controller;
  final String? hint;
  final Color? fillColor;
  final void Function(String) onChanged;
  const SearchInputField({
    Key? key,
    this.hint,
    this.fillColor,
    required this.onChanged,
    required this.controller,
  }) : super(key: key);

  @override
  OutlineInputBorder buildBorder([context, color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    );
  }

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
          hint: widget.hint,
          onChanged: widget.onChanged,
          fillColor: widget.fillColor,
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
