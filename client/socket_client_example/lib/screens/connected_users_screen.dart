import 'package:flutter/material.dart';
import 'package:socket_client_example/helpers/socket_helper.dart';
import 'package:socket_client_example/models/user.dart';

class ConnectedUsersScreen extends StatefulWidget {
  final User user;
  const ConnectedUsersScreen({super.key, required this.user});

  @override
  State<ConnectedUsersScreen> createState() => _ConnectedUsersScreenState();
}

class _ConnectedUsersScreenState extends State<ConnectedUsersScreen> {
  final List<User> _users = [];
  @override
  void initState() {
    SocketHelper.connect(user: widget.user);
    SocketHelper.on('get-connected-users', (usersData) {
      setState(() {
        final users =
            List.from(usersData).map((e) => User.fromJson(e)).toList();
        _users.clear();
        _users.addAll(users);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SocketHelper.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Users ${_users.length}'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) => Card(
          child: ListTile(
            leading: const Icon(Icons.person),
            subtitle: Text(
              "#${_users[index].id}",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            title: Text(_users[index].name +
                (_users[index].id == widget.user.id ? " (You)" : "")),
            trailing: const Icon(Icons.circle, color: Colors.green, size: 10),
          ),
        ),
        itemCount: _users.length,
      ),
    );
  }
}
