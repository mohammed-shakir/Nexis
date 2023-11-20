import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/widgets/input/base_input_field.dart';
import 'package:nexis/widgets/input/basic_input_field.dart';
import '../basic_input_field.dart';
import '../custom_button.dart';
import '../../pages/auth/utility/column_type.dart';
import 'dart:math';

class CustomColumn extends StatelessWidget {
  final ColumnType type;
  final BaseInputField? inputField;
  final String? largeLabel;
  final String? mediumLabel;
  final String? mediumBody;
  final String? smallLabel;
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;
  final GestureRecognizer? recognizer;
  final bool? obscureText;
  final String? hint;
  final void Function()? onTap;
  final void Function()? onPressed;
  final String? buttonText;
  final TextEditingController? monthController;
  final TextEditingController? dayController;
  final TextEditingController? yearController;
  final bool? readOnly;
  final Widget? suffixIcon;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final void Function()? onPressedObscureText;

  const CustomColumn({
    Key? key,
    required this.type,
    this.inputField,
    this.largeLabel,
    this.mediumLabel,
    this.mediumBody,
    this.smallLabel,
    this.controller,
    this.onSubmitted,
    this.recognizer,
    this.obscureText,
    this.hint,
    this.onTap,
    this.onPressed,
    this.buttonText,
    this.monthController,
    this.dayController,
    this.yearController,
    this.readOnly,
    this.suffixIcon,
    this.autovalidateMode,
    this.validator,
    this.onPressedObscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size contextSize = MediaQuery.of(context).size;
    List<double> margins = getMargins(type);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(type, context, largeLabel),
        sizedBox(margins[0]),
        text(type, context, mediumLabel),
        sizedBox(margins[1]),
        if (inputField != null) SizedBox(width: 500, child: inputField),
        rowCol(type, context, onTap, monthController, dayController,
            yearController, contextSize),
        sizedBox(margins[2]),
        button(type, onPressed, buttonText),
        sizedBox(margins[3]),
        richText(type, context, smallLabel, mediumBody, recognizer),
      ],
    );
  }

  heading(ColumnType type, BuildContext? context, String? largeLabel) {
    if (type != ColumnType.type1) {
      return sizedBox(0);
    }
    return Text(
      largeLabel ?? "",
      style: Theme.of(context!).textTheme.labelLarge,
    );
  }

  text(ColumnType type, BuildContext? context, String? mediumLabel) {
    if (type == ColumnType.type4) {
      return sizedBox(0);
    }
    return Text(
      mediumLabel ?? "",
      style: Theme.of(context!).textTheme.labelMedium,
    );
  }

  sizedBox(double? height) {
    return SizedBox(height: height);
  }

  richText(ColumnType type, BuildContext? context, String? smallLabel,
      String? mediumBody, GestureRecognizer? recognizer) {
    if (type == ColumnType.type4 || type == ColumnType.type2) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: smallLabel ?? "",
              style: Theme.of(context!).textTheme.labelSmall,
            ),
            TextSpan(
              text: mediumBody ?? "",
              style: Theme.of(context).textTheme.bodyMedium,
              recognizer: recognizer,
              mouseCursor: SystemMouseCursors.click,
            ),
          ],
        ),
      );
    }
    return sizedBox(0);
  }

  button(ColumnType type, void Function()? onPressed, String? buttonText) {
    if (type != ColumnType.type4) {
      return sizedBox(0);
    }
    return SizedBox(
      width: 500,
      height: 50,
      child: CustomButton(
        onPressed: onPressed,
        text: buttonText ?? "",
      ),
    );
  }

  double getDisplayWidth(Size? contextSize, double initialWidth) {
    if (contextSize!.width < 550) {
      return initialWidth * pow(0.9976, 550 - contextSize.width);
    }
    return initialWidth;
  }

  rowCol(
      ColumnType type,
      BuildContext context,
      void Function()? selectDate,
      TextEditingController? monthController,
      TextEditingController? dayController,
      TextEditingController? yearController,
      Size? contextSize) {
    if (type != ColumnType.type5) {
      return sizedBox(0);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: getDisplayWidth(contextSize!, 160),
            child: BasicInputField(
                controller: monthController!,
                onTap: selectDate,
                readOnly: true),
          ),
          SizedBox(width: getDisplayWidth(contextSize, 25)),
          SizedBox(
            width: getDisplayWidth(contextSize, 120),
            child: BasicInputField(
                controller: dayController!, onTap: selectDate, readOnly: true),
          ),
          SizedBox(width: getDisplayWidth(contextSize, 25)),
          SizedBox(
            width: getDisplayWidth(contextSize, 140),
            child: BasicInputField(
                controller: yearController!, onTap: selectDate, readOnly: true),
          ),
        ],
      ),
    );
  }
}
