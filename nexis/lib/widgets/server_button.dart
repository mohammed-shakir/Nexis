import 'package:flutter/material.dart';

class ServerButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ImageProvider? image;
  final Icon? icon;
  final Color? backgroundColor;
  final bool isSelected;
  final String name;

  const ServerButton({
    Key? key,
    required this.onPressed,
    this.image,
    this.icon,
    this.backgroundColor,
    required this.isSelected,
    required this.name,
  }) : super(key: key);

  @override
  ServerButtonState createState() => ServerButtonState();
}

class ServerButtonState extends State<ServerButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: widget.image == null
              ? (widget.isSelected || isHovering
                  ? Theme.of(context).colorScheme.secondary
                  : widget.backgroundColor)
              : widget.backgroundColor,
          borderRadius:
              BorderRadius.circular(widget.isSelected || isHovering ? 15 : 50),
          image: widget.image != null
              ? DecorationImage(
                  image: widget.image!,
                  fit: BoxFit.fill,
                )
              : null,
        ),
        child: IconButton(
          onPressed: widget.onPressed,
          color: Colors.white,
          icon:
              widget.icon ?? const Icon(Icons.photo, color: Colors.transparent),
        ),
      ),
    );
  }
}


/*
// Tooltip

@override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.name,
      padding: const EdgeInsets.all(12),
      verticalOffset: -20,
      margin: const EdgeInsets.only(left: 70),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: MouseRegion(
        onHover: (_) => setState(() => isHovering = true),
        onExit: (_) => setState(() => isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: widget.image == null
                ? (widget.isSelected || isHovering
                    ? Theme.of(context).colorScheme.secondary
                    : widget.backgroundColor)
                : widget.backgroundColor,
            borderRadius: BorderRadius.circular(
                widget.isSelected || isHovering ? 15 : 50),
            image: widget.image != null
                ? DecorationImage(
                    image: widget.image!,
                    fit: BoxFit.fill,
                  )
                : null,
          ),
          child: IconButton(
            onPressed: widget.onPressed,
            color: Colors.white,
            icon: widget.icon ??
                const Icon(Icons.photo, color: Colors.transparent),
          ),
        ),
      ),
    );
  }
*/