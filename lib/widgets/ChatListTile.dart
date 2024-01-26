import 'package:flutter/material.dart';
import 'package:nexus/screens.dart/ChatScreen.dart';
import 'package:nexus/ui/NxsTap.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile({
    super.key,
    required this.title,
    required this.lastMessage,
  });

  final String title;
  final String lastMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: const BeveledRectangleBorder(),
      child: NxsTap(
        borderRadius: BorderRadius.circular(90),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => const ChatScreen()));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
            ),
            title: Text(title),
            subtitle: Text(lastMessage),
          ),
        ),
      ),
    );
  }
}
