import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static late IO.Socket socket;

  static void connect() {
    socket = IO.io(
      "https://newebusbackend-production.up.railway.app",

      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
  }

  static void disconnect() {
    socket.dispose();
  }
}
