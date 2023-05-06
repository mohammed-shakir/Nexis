import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BasicInputField extends StatefulWidget {
  final String? labelText;
  final Color? fillColor;
  final TextStyle? labelStyle;
  final int? fontSize;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Color? borderColor;
  final VoidCallback? textControllerListenerFunction;
  final Logger? logger;

  BasicInputField(
      {Key? key,
      this.labelText,
      this.fillColor,
      this.labelStyle,
      this.fontSize,
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
    textController
        .addListener(widget.textControllerListenerFunction ?? defaultFunction);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  // Testing TextEditingController, prints current text in TextField in debug console
  void _printTest() {
    widget.logger?.i(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.labelStyle,
        border: const OutlineInputBorder(),
        fillColor: widget.fillColor ?? Theme.of(context).colorScheme.tertiary,
        filled: true,
      ),
    );
  }
}
