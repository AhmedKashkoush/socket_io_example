import 'package:socket_client_example/constants/urls.dart';
import 'package:socket_client_example/models/user.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketHelper {
  const SocketHelper._();

  static Socket? _socket;

  static void connect({required User user}) {
    if (_socket != null) return;
    _socket = io(
      Urls.baseUrl,
      OptionBuilder()
          .setTransports(['websocket'])
          .setQuery(user.toJson())
          .disableAutoConnect()
          .build(),
    );
    _socket?.connect();
  }

  static on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  static void emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
