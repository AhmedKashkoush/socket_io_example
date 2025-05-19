import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_client_example/helpers/socket_helper.dart';
import 'package:socket_client_example/models/message.dart';
import 'package:socket_client_example/models/user.dart';
import 'package:socket_client_example/widgets/chat_header.dart';
import 'package:socket_client_example/widgets/message_bubble.dart';

class ChatRoomScreen extends StatefulWidget {
  final int roomId, myId;
  final List<User> members;
  const ChatRoomScreen(
      {super.key,
      required this.roomId,
      required this.myId,
      required this.members});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messages = <Message>[];
  final List<User> _onlineUsers = [];
  late final me = widget.members.firstWhere((e) => e.id == widget.myId);
  final _messageController = TextEditingController();
  @override
  void initState() {
    SocketHelper.emit('get-connected-users');
    SocketHelper.on('get-connected-users', (usersData) {
      log("Event emitted: $_onlineUsers");
      if (!mounted) return;
      setState(() {
        final users =
            List.from(usersData).map((e) => User.fromJson(e)).toList();
        _onlineUsers.clear();
        _onlineUsers.addAll(users);
      });
    });
    SocketHelper.on('receive-message', (messageData) {
      final message = Message.fromJson(messageData);
      if (message.from == me.id || !mounted) return;
      setState(() {
        _messages.insert(0, message);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isOnline = widget.members.length == 2 &&
        _onlineUsers.map((e) => e.id).contains(widget.roomId);
    return Scaffold(
      appBar: AppBar(
        title: ChatHeader(
          name: widget.members.length > 2
              ? "Group Chat ${widget.roomId}"
              : widget.members.firstWhere((e) => e.id != widget.myId).name,
          isOnline: isOnline,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                reverse: true,
                itemBuilder: (_, index) => MessageBubble(
                  message: _messages[index],
                  me: me,
                ),
                separatorBuilder: (_, __) => const SizedBox(
                  height: 4,
                ),
                itemCount: _messages.length,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                IconButton.filled(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    final message = Message(
      from: widget.myId,
      to: widget.roomId,
      message: _messageController.text.trim(),
    );
    _messages.insert(0, message);
    SocketHelper.emit(
      'send-message',
      message.toJson(),
    );
    _messageController.clear();
    setState(() {});
  }
}
