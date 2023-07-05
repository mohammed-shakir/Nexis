import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nexis/tenor/gif_search.dart';

class InputField extends StatefulWidget {

  /* Functioning */
  final TextEditingController controller;
  final Function(String text)? controllerListenerFunction;
  final FocusNode? focusNode;
  final void Function(String)? onSubmitted;
  final Logger logger;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final GlobalKey? buttonKey;
  final GifSearchDialog? gifSearchDialog;

  /* Usability */
  final bool? readOnly;
  final int? maxLength;
  final bool? obscureText;

  final Widget? sendIcon;
  final Widget? emojiIcon;
  final Widget? gifIcon;

  final bool? includeSend;
  final bool? includeEmoji;
  final bool? includeGif;

  /* Styling */
  final String? hint;

  final Color? fillColor;

  final bool? includeBorder;
  final double? borderRadius;
  final Color? borderColor;
  final Color? focusedBorderColor;

  final TextStyle? fontStyle;
  final double? fontSize;

  final EdgeInsetsGeometry? padding;

  InputField({
    Key? key,
    required this.controller,
    this.controllerListenerFunction,
    this.focusNode,
    this.onSubmitted,
    this.autovalidateMode,
    this.validator,
    this.buttonKey,
    this.gifSearchDialog,
    this.readOnly,
    this.maxLength,
    this.obscureText,
    this.sendIcon,
    this.emojiIcon,
    this.gifIcon,
    this.includeSend,
    this.includeEmoji,
    this.includeGif,
    this.hint,
    this.fillColor,
    this.includeBorder,
    this.borderRadius,
    this.borderColor,
    this.focusedBorderColor,
    this.fontStyle,
    this.fontSize,
    this.padding,
    }) : logger = Logger(),
        super(key: key);

  @override
  State<InputField> createState() => InputFieldState();
}

class InputFieldState extends State<InputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(onChanged);
  }

  void onChanged() {
    if (widget.controllerListenerFunction != null) {
      widget.controllerListenerFunction?.call(widget.controller.text);
    } else {
      defaultListenerFunction();
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  void defaultListenerFunction() {
    widget.logger.i(widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      onFieldSubmitted: widget.onSubmitted,
      style: widget.fontStyle ?? Theme.of(context).textTheme.displayMedium,
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: Theme.of(context).textTheme.labelSmall,
        border: 
            buildBorder(
              widget.includeBorder,
              widget.borderRadius,
              widget.borderColor,
              context
            ),
        focusedBorder:
            buildBorder(
              widget.includeBorder,
              widget.borderRadius,
              widget.focusedBorderColor,
              context
            ),
        filled: true,
        fillColor: widget.fillColor ?? Colors.blueGrey[750],
      ),
    );
  }

  OutlineInputBorder buildBorder([include, size, color, context]) {
    bool includeBorder = include ?? false;
    if (includeBorder) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(size ?? 4),
        borderSide: BorderSide(
          color: color ?? Theme.of(context).colorScheme.outline,
        ),
      );
    }
    return const OutlineInputBorder(borderSide: BorderSide(width: 0.0));
  }
}
