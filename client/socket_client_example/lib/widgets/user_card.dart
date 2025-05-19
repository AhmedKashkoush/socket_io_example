import 'package:flutter/material.dart';
import 'package:socket_client_example/models/user.dart';
import 'package:socket_client_example/screens/chat_room_screen.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.user,
    required this.isOnline,
    required this.me,
  });

  final User user, me;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          if (user.id == me.id) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(
                members: [me, user],
                myId: me.id,
                roomId: user.id,
              ),
            ),
          );
        },
        leading: const Icon(Icons.person),
        subtitle: Text(
          "#${user.id}",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        title: Text(user.name + (user.id == me.id ? " (You)" : "")),
        trailing: const Icon(Icons.circle, color: Colors.green, size: 10),
      ),
    );
  }
}
