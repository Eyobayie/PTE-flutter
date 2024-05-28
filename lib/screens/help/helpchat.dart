import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final String date;
  final bool isMe;

  const ChatBubble({
    super.key,
    required this.message,
    required this.date,
    required this.isMe,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: widget.isMe ? Colors.blue[200] : Colors.grey[300],
              borderRadius: widget.isMe
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.message,
                  style: const TextStyle(color: Colors.black),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    widget.date,
                    style: const TextStyle(color: Colors.black54, fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
