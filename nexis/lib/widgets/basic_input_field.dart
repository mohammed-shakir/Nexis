import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BasicInputField extends StatefulWidget {
  final String? labelText;
  final Color? fillColor;
  final TextStyle? labelStyle;
  final TextStyle? fontStyle;
  final double? fontSize;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final Function(String text)? textControllerListenerFunction;
  final Function(String)? onSubmitted;
  final Logger logger;
  final TextEditingController textController;
  final FocusNode focusNode = FocusNode();

  BasicInputField(
      {Key? key,
      this.labelText,
      this.fillColor,
      this.labelStyle,
      this.fontSize,
      this.border,
      this.focusedBorder,
      this.padding,
      this.borderRadius,
      this.borderColor,
      this.fontStyle,
      this.onSubmitted,
      this.textControllerListenerFunction})
      : logger = Logger(),
        textController = TextEditingController(),
        super(key: key);

  @override
  State<BasicInputField> createState() => _BasicInputField();
}

class _BasicInputField extends State<BasicInputField> {
  @override
  void initState() {
    super.initState();
    widget.textController.addListener(onChanged);
  }

  void onChanged() {
    if (widget.textControllerListenerFunction != null) {
      widget.textControllerListenerFunction?.call(widget.textController.text);
    } else {
      defaultListenerFunction();
    }
  }

  @override
  void dispose() {
    widget.textController.dispose();
    super.dispose();
  }

  void defaultListenerFunction() {
    widget.logger.i(widget.textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.textController,
      onSubmitted: (value) {
        widget.onSubmitted?.call(value);
        widget.textController.clear();
        setState(() {});
        widget.focusNode.requestFocus();
      },
      style: widget.fontStyle ?? Theme.of(context).textTheme.displayMedium,
      cursorColor: Theme.of(context).colorScheme.secondary,
      decoration: InputDecoration(
        // Tested done on chrome, android:
        // labelText, labelStyle, border, fillColor, focusedBorder, fontsize
        labelText: widget.labelText ?? 'Enter your message',
        labelStyle:
            widget.labelStyle ?? Theme.of(context).textTheme.displayMedium,

        border: widget.border ??
            const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
        fillColor: widget.fillColor ?? Theme.of(context).colorScheme.tertiary,
        filled: true,
        focusedBorder: widget.focusedBorder ??
            const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
      ),
    );
  }
}
