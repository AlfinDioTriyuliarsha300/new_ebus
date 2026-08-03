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
          .enableReconnection()
          .setReconnectionAttempts(999999)
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(5000)
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

    _socket!.onReconnect((_) {
      print("🟢 Socket Reconnected");
    });

    _socket!.onReconnectAttempt((attempt) {
      print("🔄 Reconnect Attempt : $attempt");
    });

    _socket!.onReconnectError((error) {
      print("❌ Reconnect Error : $error");
    });

    _socket!.onReconnectFailed((_) {
      print("❌ Reconnect Failed");
    });

    _socket!.onConnectError((data) {
      print("Socket Error : $data");
    });

    _socket!.onError((data) {
      print("Socket Error : $data");
    });
  }

  void disconnect() {
    _socket?.off("bus_location");
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}
