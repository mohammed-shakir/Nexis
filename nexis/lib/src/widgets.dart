import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget? child;
  final String? text;
  final Function() onPressed;
  final TextStyle? textStyle;

  const CustomButton({
    Key? key,
    this.child,
    this.text,
    required this.onPressed,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 14.0,
        ),
      ),
      onPressed: onPressed,
      child: child ??
          Text(
            text!,
            style: textStyle ??
                const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Arial',
                  fontSize: 14.0,
                ),
          ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CustomText({
    Key? key,
    required this.text,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontFamily: 'Arial',
        fontSize: 14.0,
      ).merge(style),
    );
  }
}
