import 'package:flutter/material.dart';

class ChannelButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ImageProvider? image;
  final Icon? icon;
  final Color? backgroundColor;
  final bool isSelected;
  final String name;
  final double? size;

  const ChannelButton({
    Key? key,
    required this.onPressed,
    this.image,
    this.icon,
    this.backgroundColor,
    required this.isSelected,
    required this.name,
    this.size,
  }) : super(key: key);

  @override
  ChannelButtonState createState() => ChannelButtonState();
}

class ChannelButtonState extends State<ChannelButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 12, horizontal: 8)),
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(MaterialState.hovered) || widget.isSelected) {
                return Theme.of(context).colorScheme.tertiary;
              } else {
                return Theme.of(context).colorScheme.background;
              }
            },
          ),
          side: MaterialStateProperty.resolveWith((states) => BorderSide.none),
          elevation: MaterialStateProperty.all(0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.image != null) ...[
              Container(
                width: widget.size ?? 32,
                height: widget.size ?? 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: widget.image!, fit: BoxFit.fill),
                ),
              ),
              const SizedBox(width: 10),
            ] else if (widget.icon != null) ...[
              SizedBox(
                width: widget.size ?? 32,
                height: widget.size ?? 32,
                child: widget.icon,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              widget.name,
              style: TextStyle(
                color: widget.isSelected || isHovering
                    ? Colors.white
                    : Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
