import 'package:flutter/material.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.name,
    required this.isOnline,
  });

  final String name;
  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(name),
      subtitle: !isOnline
          ? null
          : const Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 10),
                SizedBox(
                  width: 4,
                ),
                Text("Online")
              ],
            ),
    );
  }
}
