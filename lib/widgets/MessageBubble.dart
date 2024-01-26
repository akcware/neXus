import 'package:flutter/material.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({super.key, this.isReceived = true, required this.text});

  final String text;
  final bool isReceived;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          widget.isReceived ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: Card(
            color: widget.isReceived ? Colors.white : Colors.black,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.text,
                style: TextStyle(
                    color: widget.isReceived ? Colors.black : Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
