import 'package:flutter/material.dart';
import 'package:socket_client_example/helpers/socket_helper.dart';
import 'package:socket_client_example/models/user.dart';
import 'package:socket_client_example/widgets/user_card.dart';

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
        itemBuilder: (context, index) => UserCard(
          user: _users[index],
          me: widget.user,
          isOnline: _users.map((e) => e.id).contains(
                _users[index].id,
              ),
        ),
        itemCount: _users.length,
      ),
    );
  }
}
