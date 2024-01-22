import 'package:flutter/material.dart';

class MessageHoverMenu extends StatelessWidget {
  final bool isMessageOwner;
  final VoidCallback onDelete;
  final VoidCallback onReply;
  final VoidCallback onAddReaction;

  const MessageHoverMenu({
    Key? key,
    required this.isMessageOwner,
    required this.onDelete,
    required this.onReply,
    required this.onAddReaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: Colors.grey[900],
      onSelected: (String value) {
        switch (value) {
          case 'Delete':
            onDelete();
            break;
          case 'Reply':
            onReply();
            break;
          case 'Add Reaction':
            onAddReaction();
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        if (isMessageOwner)
          const PopupMenuItem<String>(
            value: 'Delete',
            child: Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        const PopupMenuItem<String>(
          value: 'Reply',
          child: Text(
            'Reply',
            style: TextStyle(color: Colors.white),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Add Reaction',
          child: Text(
            'Add Reaction',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
      icon: _horizontalMenuIcon(),
    );
  }

  Widget _horizontalMenuIcon() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 5, color: Colors.white),
        SizedBox(width: 2),
        Icon(Icons.circle, size: 5, color: Colors.white),
        SizedBox(width: 2),
        Icon(Icons.circle, size: 5, color: Colors.white),
      ],
    );
  }
}
