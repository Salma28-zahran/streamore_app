// chat_cubit.dart
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamore_app/features/tabs/chat/bloc/chat_states.dart';
import 'package:web_socket_channel/io.dart';

class ChatCubit extends Cubit<ChatState> {
  IOWebSocketChannel? _channel;
  final List<Map<String, dynamic>> _messages = [];
  final List<String> _typingUsers = [];
  Timer? _typingTimer;

  ChatCubit() : super(ChatInitial());

  void connect(String baseUrl, String token) {
    final url = baseUrl.startsWith('ws://') || baseUrl.startsWith('wss://')
        ? "$baseUrl/ws/chat/?token=${Uri.encodeQueryComponent(token)}"
        : "ws://$baseUrl/ws/chat/?token=${Uri.encodeQueryComponent(token)}";

    print("🔗 Trying to connect to WebSocket: $url");

    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(url));
      print("✅ WebSocket connected successfully.");
      emit(ChatConnected());

      _channel!.stream.listen((message) {
        print("📩 Message received from server: $message");
        try {
          final data = jsonDecode(message);
          print("🔍 Decoded JSON: $data");

          final type = data['type'];
          if (type == 'message') {
            final map = Map<String, dynamic>.from(data);
            // ➕ نحفظ الرسالة محلياً ثم نرسل الـ state كقائمة
            _messages.add(map);
            print("🗂 Stored message locally. total=${_messages.length}");
            emit(ChatMessageReceived(List.from(_messages)));

            // لو المرسل موجود في typing users نشيله
            final sender = map['sender']?.toString() ?? map['sender_id']?.toString();
            if (sender != null && _typingUsers.contains(sender)) {
              _typingUsers.remove(sender);
              emit(ChatTypingUsersUpdated(List.from(_typingUsers)));
            }
          } else if (type == 'typing') {
            final username = data['username']?.toString();
            if (username != null && !_typingUsers.contains(username)) {
              _typingUsers.add(username);
              emit(ChatTypingUsersUpdated(List.from(_typingUsers)));
            }
            _typingTimer?.cancel();
            _typingTimer = Timer(const Duration(seconds: 3), () {
              _typingUsers.remove(username);
              emit(ChatTypingUsersUpdated(List.from(_typingUsers)));
            });
          } else if (type == 'user_status') {
            final users = List<String>.from(data['active_users'] ?? []);
            emit(ChatActiveUsersUpdated(users));
          } else {
            print("⚠️ Unknown event type: $type");
          }
        } catch (e) {
          print("❌ Error decoding/handling message: $e");
        }
      }, onError: (error) {
        print("🚨 WebSocket error: $error");
        emit(ChatError(error.toString()));
      }, onDone: () {
        print("🔌 WebSocket connection closed.");
        emit(ChatDisconnected());
      });
    } catch (e) {
      print("❌ Failed to connect WebSocket: $e");
      emit(ChatError(e.toString()));
    }
  }

  void sendMessage(String senderId, String content) {
    if (_channel == null) {
      print("🚫 Cannot send message. WebSocket not connected.");
      return;
    }
    final message = jsonEncode({
      "type": "message",
      "sender_id": senderId,
      "content": content,
    });

    print("📤 Sending message: $message");
    try {
      _channel!.sink.add(message);
    } catch (e) {
      print("❌ Failed to send message: $e");
      emit(ChatError("Failed to send message: $e"));
    }
  }

  @override
  Future<void> close() {
    print("👋 Closing WebSocket connection...");
    try {
      _channel?.sink.close();
    } catch (_) {}
    _typingTimer?.cancel();
    return super.close();
  }
}
