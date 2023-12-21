import 'package:flutter/material.dart';

class SelectButton extends StatefulWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final Color pressedBackgroundColor;
  final Color pressedTextColor;
  final Color hoverTextColor;
  final VoidCallback onPressed;

  const SelectButton({
    Key? key,
    required this.text,
    required this.color,
    required this.backgroundColor,
    required this.pressedBackgroundColor,
    required this.pressedTextColor,
    required this.hoverTextColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  SelectButtonState createState() => SelectButtonState();
}

class SelectButtonState extends State<SelectButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onPressed,
      onHover: (hovering) {
        setState(() => _isHovered = hovering);
      },
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Material(
        color:
            _isPressed ? widget.pressedBackgroundColor : widget.backgroundColor,
        borderRadius: BorderRadius.circular(4.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Text(
            widget.text,
            style: TextStyle(
              color: _isPressed
                  ? widget.pressedTextColor
                  : (_isHovered ? widget.hoverTextColor : widget.color),
            ),
          ),
        ),
      ),
    );
  }
}
