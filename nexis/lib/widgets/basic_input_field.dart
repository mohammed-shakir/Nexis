import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BasicInputField extends StatefulWidget {
  final String? labelText;
  final Color? fillColor;
  final TextStyle? labelStyle;
  final double? fontSize;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final VoidCallback? textControllerListenerFunction;
  final Logger logger;

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
      this.textControllerListenerFunction})
      : logger = Logger(),
        super(key: key);

  @override
  State<BasicInputField> createState() => _BasicInputField();
}

class _BasicInputField extends State<BasicInputField> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(
        widget.textControllerListenerFunction ?? defaultListenerFunction);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void defaultListenerFunction() {
    widget.logger.i(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        // Tested done on chrome, android:
        // labelText, labelStyle, border, fillColor, focusedBorder, fontsize
        labelText: widget.labelText ?? 'Enter your message',
        labelStyle: widget.labelStyle ?? const TextStyle(color: Colors.white),
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
