import 'package:flutter/material.dart';
import 'package:socket_client_example/models/message.dart';
import 'package:socket_client_example/models/user.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final User me;
  const MessageBubble({
    super.key,
    required this.message,
    required this.me,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.from == me.id
          ? AlignmentDirectional.centerEnd
          : AlignmentDirectional.centerStart,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: message.from == me.id
              ? Theme.of(context).primaryColor
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Flexible(
          child: Text(
            message.message,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: message.from == me.id ? Colors.white : null,
            ),
          ),
        ),
      ),
    );
  }
}
