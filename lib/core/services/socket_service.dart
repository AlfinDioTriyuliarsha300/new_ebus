import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/api_constants.dart';

class SocketService {
  SocketService._();

  static final SocketService instance = SocketService._();

  io.Socket? _socket;

  io.Socket? get socket => _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect() {
    if (_socket != null && _socket!.connected) {
      return;
    }

    final socketUrl = ApiConstants.baseUrl.replaceAll('/api', '');

    _socket = io.io(
      socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print("🟢 Socket Connected");
    });

    _socket!.onDisconnect((_) {
      print("🔴 Socket Disconnected");
    });

    _socket!.onConnectError((data) {
      print("Socket Error : $data");
    });

    _socket!.onError((data) {
      print("Socket Error : $data");
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
