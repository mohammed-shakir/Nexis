import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius; 
  final Logger logger;

  CustomButton({
    Key? key,
    this.text = 'Button',
    this.onPressed,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.textColor,
  })  : logger = Logger(),
        super(key: key);

  VoidCallback get defaultOnPress => () {
        logger.i("Button pressed");
  };

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? defaultOnPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.secondary,
        foregroundColor: textColor ?? Theme.of(context).textTheme.labelLarge?.color,
        padding: padding ?? EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: borderRadius ?? BorderRadius.circular(4)),
      ),
      child: Text(text),
    );
  }
}