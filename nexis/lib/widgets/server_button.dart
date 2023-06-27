import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'dart:async';

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
  late final JustTheController _tooltipController;
  Timer? _hoverTimer;

  @override
  void initState() {
    super.initState();
    _tooltipController = JustTheController();
  }

  @override
  void dispose() {
    _tooltipController.dispose();
    _hoverTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        if (!widget.isSelected) {
          setState(() => isHovering = true);
          _hoverTimer?.cancel();
          _hoverTimer = Timer(const Duration(milliseconds: 200), () {
            _tooltipController.showTooltip(immediately: true);
          });
        }
      },
      onExit: (_) {
        _hoverTimer?.cancel();
        setState(() {
          isHovering = false;
        });
        _tooltipController.hideTooltip();
      },
      child: JustTheTooltip(
        controller: _tooltipController,
        content: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            widget.name,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        backgroundColor: Colors.black,
        preferredDirection: AxisDirection.right,
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            if (isHovering || widget.isSelected)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeInOut,
                    width: 4,
                    height: widget.isSelected ? 40 : 20,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            Center(
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
                      const Icon(
                        Icons.photo,
                        color: Colors.transparent,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
