// core/services/chat_websocket_manager.dart
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatWebsocketManager {
  ChatWebsocketManager._private();
  static final ChatWebsocketManager instance = ChatWebsocketManager._private();

  WebSocketChannel? _channel;

  final StreamController<Map<String, dynamic>> _controller = StreamController.broadcast();
  Stream<Map<String, dynamic>> get stream => _controller.stream;

  bool _manualClose = false;
  bool _isConnected = false;
  bool _isConnecting = false;
  int _retryAttempts = 0;

  // ===== WebSocket Connect =====
  Future<void> connect({required String token, required int chatId}) async {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    _manualClose = false;

    final url = "ws://34.39.27.45:8000/ws/chat/$chatId/?token=$token";
    print("🔌 Connecting to: $url");

    try {
      _channel = IOWebSocketChannel.connect(url);

      _channel!.stream.listen(
            (message) {
          try {
            final data = jsonDecode(message);
            print("🔹 Incoming WS data: $data");
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
          print("⚠️ Connection closed (onDone)");
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
      case "user_status":
      case "user_status_update":
      case "participants_status":
      case "typing_update":
      case "chat_message":
        _controller.add(data);
        break;
      default:
        _controller.add({'type': 'unknown', 'data': data});
    }
  }

  void _retryWithBackoff(String token, int chatId) {
    _retryAttempts++;
    final delaySeconds = (min(30, pow(2, _retryAttempts)) + Random().nextInt(3)).toInt();
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

  // ===== BASE URL =====
  final String baseUrl = "http://34.39.27.45:8000/api";

  // ===== REST API Helpers =====
  Future<Map<String, dynamic>?> createChat({
    required String token,
    required List<int> userIds,
    bool isGroup = false,
    String name = "",
  }) async {
    final url = Uri.parse("$baseUrl/chat/create/");
    try {
      final resp = await http.post(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_ids": userIds,
          "is_group": isGroup,
          "name": name,
        }),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        final data = jsonDecode(resp.body);
        print("✅ Chat created: $data");
        return data;
      } else {
        print("❌ Failed to create chat: ${resp.body}");
      }
    } catch (e) {
      print("❌ Exception creating chat: $e");
    }
    return null;
  }

  Future<void> sendMessage({
    required String token,
    required int chatId,
    required String content,
  }) async {
    final url = Uri.parse("$baseUrl/message/$chatId/send/");
    try {
      final resp = await http.post(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"content": content}),
      );

      if (resp.statusCode == 200 || resp.statusCode == 201) {
        print("📤 Message sent: $content");
      } else {
        print("❌ Failed to send message: ${resp.body}");
      }
    } catch (e) {
      print("❌ Exception sending message: $e");
    }
  }

  Future<void> sendMedia({
    required String token,
    required int chatId,
    required String mediaPath,
  }) async {
    final url = Uri.parse("$baseUrl/media_message/$chatId/upload/");
    try {
      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Token $token';
      request.files.add(await http.MultipartFile.fromPath('media', mediaPath));
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("📤 Media uploaded: $mediaPath");
      } else {
        print("❌ Failed to upload media: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception uploading media: $e");
    }
  }

  Future<void> sendExit({
    required String token,
    required int chatId,
  }) async {
    final url = Uri.parse("$baseUrl/chat/$chatId/exit/");
    try {
      final resp = await http.post(
        url,
        headers: {'Authorization': 'Token $token'},
      );
      if (resp.statusCode == 200) {
        print("✅ Exited chat");
      } else {
        print("❌ Failed to exit chat: ${resp.body}");
      }
    } catch (e) {
      print("❌ Exception exiting chat: $e");
    }
  }

  Future<void> requestParticipants({
    required String token,
    required int chatId,
  }) async {
    final url = Uri.parse("$baseUrl/chat_participants_status/$chatId/");
    try {
      final resp = await http.get(
        url,
        headers: {'Authorization': 'Token $token'},
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        _controller.add({'type': 'participants_status', 'data': data});
        print("📥 Participants loaded");
      } else {
        print("❌ Failed to load participants: ${resp.body}");
      }
    } catch (e) {
      print("❌ Exception fetching participants: $e");
    }
  }

  void sendMessage2(Map<String, dynamic> data) {
    if (_channel != null) {
      try {
        final encoded = jsonEncode(data);
        _channel!.sink.add(encoded);
        print("📤 WS Message sent: $encoded");
      } catch (e) {
        print("❌ Failed to send WS message: $e");
      }
    } else {
      print("⚠️ Cannot send WS message → not connected");
    }
  }
}
