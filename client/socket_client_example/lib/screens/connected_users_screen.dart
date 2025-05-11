import 'dart:developer';

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
    SocketHelper.on('user-connected', (usersData) {
      log("$usersData");
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
        itemBuilder: (context, index) => ListTile(
          leading: Text("#${_users[index].id}"),
          title: Text(_users[index].name),
          trailing: const Icon(Icons.circle, color: Colors.green, size: 10),
        ),
        itemCount: _users.length,
      ),
    );
  }
}
