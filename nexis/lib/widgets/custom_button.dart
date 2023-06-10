import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Icon? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Logger logger;

  CustomButton({
    Key? key,
    this.text,
    this.icon,
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
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.secondary,
        foregroundColor:
            textColor ?? Theme.of(context).textTheme.labelLarge?.color,
        padding: padding ?? const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(4)),
      ),
      child: icon == null
          ? Text(text ?? 'Button')
          : text == null
              ? icon
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon!,
                    const SizedBox(width: 8),
                    Text(text!),
                  ],
                ),
    );
  }
}
