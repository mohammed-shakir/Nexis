import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:nexis/widgets/auth/custom_input_field.dart';
import '../custom_button.dart';
import 'column_type.dart';
import 'size_helper.dart';

class CustomColumn extends StatelessWidget {
  final ColumnType type;
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

  const CustomColumn(
    this.type,
    {this.largeLabel,
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
    super.key
    });

  @override
  Widget build(BuildContext context) {
    List<double> margins = getMargins(type);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        heading(type, context, largeLabel),
        sizedBox(margins[0]),
        text(type, context, mediumLabel),
        sizedBox(margins[1]),
        textField(type, controller, onSubmitted, obscureText, hint, onTap),
        rowCol(type, context, onTap, monthController, dayController, yearController),
        sizedBox(margins[2]),
        richText(type, context, mediumBody, recognizer),
        button(type, onPressed, buttonText),
        sizedBox(margins[3]),
        richText2(type, context, smallLabel, mediumBody, recognizer),
      ],
    );
  }

  heading(ColumnType type, BuildContext? context, String? largeLabel) {
    if (type != ColumnType.type1) { return sizedBox(0); }
    return Text(
      largeLabel ?? "", 
      style: Theme.of(context!).textTheme.labelLarge,
    );
  }

  textField(ColumnType type, TextEditingController? controller, void Function(String)? onSubmitted, bool? obscureText, 
    String? hint, void Function()? onTap) {
    if (type == ColumnType.type4 || type == ColumnType.type5) { return sizedBox(0); }
    return SizedBox(
      width: 500,
      child: CustomTextField(
        obscureText: obscureText ?? false,
        hint: hint ?? '',
        controller: controller,
        onSubmitted: onSubmitted,
        onTap: onTap,
      ),
    );
  }

  text(ColumnType type, BuildContext? context, String? mediumLabel){
    if (type == ColumnType.type4) { return sizedBox(0); }
    return Text(
      mediumLabel ?? "", 
      style: Theme.of(context!).textTheme.labelMedium,
    );
  }

  sizedBox(double? height) {
    return SizedBox(height: height);
  }

  richText(ColumnType type, BuildContext? context, String? mediumBody, GestureRecognizer? recognizer) {
    if (type != ColumnType.type2) { return sizedBox(0); }
    return RichText(
      text: TextSpan(
        text: mediumBody ?? "", 
        style: Theme.of(context!).textTheme.bodyMedium,
        recognizer: recognizer,
        mouseCursor: SystemMouseCursors.click,
      ),
    );
  }
  richText2(ColumnType type, BuildContext? context, String? smallLabel, String? mediumBody, GestureRecognizer? recognizer) {
    if (type != ColumnType.type4) { return sizedBox(0); }
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

  button(ColumnType type, void Function()? onPressed, String? buttonText) {
    if (type != ColumnType.type4) { return sizedBox(0); }
    return SizedBox(
      width: 500,
      height: 50,
      child: CustomButton(
        onPressed: onPressed,
        text: buttonText ?? "",
      ),
    );
  }

  rowCol(ColumnType type, BuildContext? context, void Function()? selectDate, TextEditingController? monthController, 
    TextEditingController? dayController, TextEditingController? yearController) {
    if (type != ColumnType.type5) { return sizedBox(0); }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(
            width: displayWidth(context!,160,0.275),
            child: CustomTextField(
              obscureText: false,
              hint: 'Month',
              onTap: selectDate,
              controller: monthController,
              readOnly: true,
            ),
          ),
          SizedBox(width: displayWidth(context,25,0.039)),
          SizedBox(
            width: displayWidth(context,120,0.215),
            child: CustomTextField(
              obscureText: false,
              hint: 'Day',
              onTap: selectDate,
              controller: dayController,
              readOnly: true,
            ),
          ),
          SizedBox(width: displayWidth(context,25,0.039)),
          SizedBox(
            width: displayWidth(context,140,0.255),
            child: CustomTextField(
              obscureText: false,
              hint: 'Year',
              onTap: selectDate,
              controller: yearController,
              readOnly: true,
            ),
          ),
        ],
      ),
    );
  }
}