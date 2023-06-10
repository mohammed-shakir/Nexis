import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NavigationMenuItem extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const NavigationMenuItem({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.color = Colors.transparent,
  }) : super(key: key);

  @override
  NavigationMenuItemState createState() => NavigationMenuItemState();
}

class NavigationMenuItemState extends State<NavigationMenuItem> {
  bool isHovered = false;
  SystemMouseCursor cursor = SystemMouseCursors.click;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    if (widget.title == 'Logout') {
      backgroundColor = const Color.fromARGB(255, 181, 12, 0);
    } else if (widget.isSelected) {
      backgroundColor = Colors.red;
    } else if (isHovered) {
      backgroundColor = Colors.grey[700]!;
    } else {
      backgroundColor = Colors.transparent;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: cursor,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: widget.onTap,
          child: ListTile(
            title: Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
