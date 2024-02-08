import 'package:flutter/material.dart';

class MessageOptionsMenu extends StatelessWidget {
  final bool isMessageOwner;
  final VoidCallback onDelete;
  final VoidCallback onReply;
  final VoidCallback onAddReaction;
  final Function(bool) onMenuToggle;

  const MessageOptionsMenu({
    Key? key,
    required this.isMessageOwner,
    required this.onDelete,
    required this.onReply,
    required this.onAddReaction,
    required this.onMenuToggle,
  }) : super(key: key);

  void _showMenu(BuildContext context) {
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final button = context.findRenderObject() as RenderBox;
    final position = button.localToGlobal(Offset.zero, ancestor: overlay);
    final size = button.size;
    onMenuToggle(true);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy,
      ),
      items: [
        if (isMessageOwner)
          PopupMenuItem<String>(
            value: 'Delete',
            onTap: onDelete,
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        PopupMenuItem<String>(
          value: 'Reply',
          onTap: onReply,
          child: const Text('Reply', style: TextStyle(color: Colors.white)),
        ),
        PopupMenuItem<String>(
          value: 'Add Reaction',
          onTap: onAddReaction,
          child:
              const Text('Add Reaction', style: TextStyle(color: Colors.white)),
        ),
      ],
      color: Colors.grey[900],
    ).then((value) {
      onMenuToggle(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showMenu(context),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _horizontalMenuIcon(),
        ),
      ),
    );
  }

  Widget _horizontalMenuIcon() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 4, color: Colors.white),
        SizedBox(width: 2),
        Icon(Icons.circle, size: 4, color: Colors.white),
        SizedBox(width: 2),
        Icon(Icons.circle, size: 4, color: Colors.white),
      ],
    );
  }
}
