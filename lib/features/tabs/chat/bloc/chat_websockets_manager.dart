import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebsocketManager {
  ChatWebsocketManager._private();
  static final ChatWebsocketManager instance = ChatWebsocketManager._private();

  WebSocketChannel? _channel;

  final StreamController<Map<String, dynamic>> _controller =
  StreamController.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  bool _manualClose = false;
  bool _isConnected = false;
  bool _isConnecting = false;
  int _retryAttempts = 0;

  // ===== Connect to WebSocket =====
  Future<void> connect({required String token, required int chatId}) async {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    _manualClose = false;

    final url = "wss://api.streamore.net/ws/chat/$chatId/?token=$token";
    print("🔌 Connecting to: $url");

    try {
      _channel = IOWebSocketChannel.connect(url);

      _channel!.stream.listen(
            (message) {
          try {
            final data = jsonDecode(message);
            print("📥 Incoming WS data: $data");
            _handleMessage(data);
          } catch (e) {
            _controller.add({'type': 'error', 'error': 'Invalid JSON: $e'});
          }
        },
        onError: (err) {
          print("❌ WS Error: $err");
          _isConnected = false;
          _isConnecting = false;
          _controller.add({'type': 'error', 'error': err.toString()});
          if (!_manualClose) _retryWithBackoff(token, chatId);
        },
        onDone: () {
          print("⚠️ Connection closed");
          _isConnected = false;
          _isConnecting = false;
          _controller.add({'type': 'connection', 'status': 'closed'});
          if (!_manualClose) _retryWithBackoff(token, chatId);
        },
        cancelOnError: true,
      );

      _isConnected = true;
      _isConnecting = false;
      _retryAttempts = 0;
      _controller.add({'type': 'connection', 'status': 'connected'});
    } catch (e) {
      print("❌ Connection failed: $e");
      _isConnected = false;
      _isConnecting = false;
      if (!_manualClose) _retryWithBackoff(token, chatId);
    }
  }

  void _handleMessage(Map<String, dynamic> data) {
    switch (data['type']) {
      case "message": // 📩 رسالة جديدة
        _controller.add(data);
        break;
      case "typing": // ⌨️ حد بيكتب
        _controller.add(data);
        break;
      case "seen": // 👀 رسائل اتعملها seen
        _controller.add(data);
        break;
      case "user_status": // 🟢 مين أونلاين
        _controller.add(data);
        break;
      default:
        _controller.add({'type': 'unknown', 'data': data});
    }
  }

  void _retryWithBackoff(String token, int chatId) {
    _retryAttempts++;
    final delaySeconds =
    (min(30, pow(2, _retryAttempts)) + Random().nextInt(3)).toInt();
    print("⏳ Retrying in $delaySeconds seconds (attempt $_retryAttempts)...");
    Future.delayed(Duration(seconds: delaySeconds), () {
      if (!_manualClose) connect(token: token, chatId: chatId);
    });
  }

  void disconnect({bool manual = true}) {
    _manualClose = manual;
    _isConnected = false;
    try {
      _channel?.sink.close();
    } catch (e) {
      print("⚠️ Error closing socket: $e");
    }
    _controller.add({
      'type': 'connection',
      'status': manual ? 'manual_closed' : 'disposed',
    });
  }

  Future<void> dispose() async {
    disconnect(manual: true);
    if (!_controller.isClosed) await _controller.close();
  }

  // ====== Sending WebSocket events ======
  void sendMessage({
    required int senderId,
    required String content,
    dynamic media,
  }) {
    final payload = {
      "type": "message",
      "sender_id": senderId,
      "content": content,
      if (media != null) "media": media,
    };
    _send(payload);
  }

  void sendTyping(String username) {
    final payload = {"type": "typing", "username": username};
    _send(payload);
  }

  void sendSeen(List<int> ids) {
    final payload = {"type": "seen", "message_ids": ids};
    _send(payload);
  }

  void _send(Map<String, dynamic> data) {
    if (_channel != null) {
      final encoded = jsonEncode(data);
      _channel!.sink.add(encoded);
      print("📤 WS Message sent: $encoded");
    } else {
      print("⚠️ Cannot send WS message → not connected");
    }
  }
}
