import 'package:flutter/material.dart';

class HoverIconButton extends StatefulWidget {
  final Icon icon;
  final VoidCallback onPressed;
  final Color color;
  final Color hoverColor;
  final EdgeInsetsGeometry? padding;
  final double? size;

  const HoverIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.color,
    required this.hoverColor,
    this.padding,
    this.size,
  }) : super(key: key);

  @override
  HoverIconButtonState createState() => HoverIconButtonState();
}

class HoverIconButtonState extends State<HoverIconButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: IconButton(
        icon: widget.icon,
        onPressed: widget.onPressed,
        color: isHovering ? widget.hoverColor : widget.color,
        padding: widget.padding ?? const EdgeInsets.all(0),
        iconSize: widget.size ?? 24,
      ),
    );
  }
}
