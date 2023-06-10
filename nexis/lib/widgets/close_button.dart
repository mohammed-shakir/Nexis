import 'package:flutter/material.dart';

class CustomCloseButton extends StatefulWidget {
  final VoidCallback onPressed;
  const CustomCloseButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  CustomCloseButtonState createState() => CustomCloseButtonState();
}

class CustomCloseButtonState extends State<CustomCloseButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isHovered ? Colors.grey : null,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        width: 40,
        height: 40,
        alignment: Alignment.center,
        child: const Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
    );
  }
}
