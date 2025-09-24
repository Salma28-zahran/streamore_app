import 'dart:async';
import 'package:flutter/material.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/core/services/chat_service.dart';
import 'package:streamore_app/features/tabs/chat/bloc/chat_websockets_manager.dart'
    show ChatWebsocketManager;

class ChatMessage {
  final String sender;
  final String content;
  final String? timestamp;
  final bool isMe;
  final bool isMedia;

  ChatMessage({
    required this.sender,
    required this.content,
    this.timestamp,
    this.isMe = false,
    this.isMedia = false,
  });
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();

  String? _email;
  String? _token;
  int _chatId = 0;

  StreamSubscription? _sub;
  List<String> _typingUsers = [];
  List<String> _activeUsers = [];
  Timer? _typingTimer;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _initSetup();
  }

  Future<void> _initSetup() async {
    _token = await StorageHelper.getToken();
    _email = await StorageHelper.getEmail();
    final myUserId = await StorageHelper.getUserId();

    if (_token == null || _email == null || myUserId == null) {
      print("❌ Missing token, email, or userId");
      return;
    }

    final newChat = await ChatService.createChat(
      _token!,
      userIds: [myUserId, 21],
      isGroup: true,
      name: "Study Group",
    );

    print("📦 newChat response: $newChat");


    if (newChat != null && newChat['chat'] != null && newChat['chat']['id'] != null) {
      _chatId = newChat['chat']['id'] as int;
      print("✅ Chat ID extracted: $_chatId");
    } else {
      print("❌ Failed to create chat or missing ID");
      return;
    }


    print("✅ Chat created with ID: $_chatId");

    ChatWebsocketManager.instance.connect(
      token: _token!,
      chatId: _chatId,
    );

    _sub = ChatWebsocketManager.instance.stream.listen(_handleSocketEvent);

    if (!mounted) return;
    setState(() {});
  }

  void _handleSocketEvent(Map<String, dynamic> data) {

    final type = data['type'];

    switch (type) {
      case 'chat_message':
        String sender = 'server';
        if (data['sender'] != null) {
          if (data['sender'] is Map<String, dynamic>) {
            sender = data['sender']['username'] ?? 'server';
          } else if (data['sender'] is String) {
            sender = data['sender'];
          }
        }

        final content = data['content'] ?? '';
        final timestamp = data['timestamp']?.toString() ?? DateTime.now().toIso8601String();

        setState(() {
          _messages.add(ChatMessage(
            sender: sender,
            content: content,
            timestamp: timestamp,
            isMe: sender == _email!.split('@')[0],
          ));
        });
        break;

      case 'typing_update':
        final user = data['user'] as String? ?? "";
        final isTyping = data['is_typing'] == true;

        setState(() {
          if (isTyping) {
            if (!_typingUsers.contains(user) && user != _email!.split('@')[0]) {
              _typingUsers.add(user);
            }
          } else {
            _typingUsers.remove(user);
          }
        });
        break;

      case 'user_status':
      case 'user_status_update':
        final users = List<String>.from(data['active_users'] ?? []);
        setState(() {
          _activeUsers = users;
        });
        break;

      default:
        print("ℹ️ Other event: $data");
    }
  }



  void _sendMessageWS(String text) {
    if (text.trim().isEmpty || _email == null) return;

    final timestamp = DateTime.now().toIso8601String();

    final localMessage = ChatMessage(
      sender: _email!.split('@')[0],
      content: text.trim(),
      timestamp: timestamp,
      isMe: true,
    );

    setState(() {
      _messages.add(localMessage);
    });

    final message = {
      'type': 'chat_message',
      'chat_id': _chatId,
      'content': text.trim(),
      'timestamp': timestamp,
    };

    ChatWebsocketManager.instance.sendMessage2(message);
    _controller.clear();
    _sendStopTyping();
  }


  void _sendStartTyping() {
    if (_email == null) return;

    final msg = {
      'type': 'typing_update',
      'chat_id': _chatId,
      'is_typing': true,
    };

    ChatWebsocketManager.instance.sendMessage2(msg);
    _isTyping = true;
  }

  void _sendStopTyping() {
    if (_email == null || !_isTyping) return;

    final msg = {
      'type': 'typing_update',
      'chat_id': _chatId,
      'is_typing': false,
    };

    ChatWebsocketManager.instance.sendMessage2(msg);
    _isTyping = false;
  }

  void _sendExit() {
    final msg = {
      'type': 'exit_chat',
      'chat_id': _chatId,
    };

    ChatWebsocketManager.instance.sendMessage2(msg);
  }

  void _resetTypingTimer() {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), () {
      _sendStopTyping();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    ChatWebsocketManager.instance.disconnect();
    _controller.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_activeUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Active users: ${_activeUsers.join(', ')}",
                style: const TextStyle(fontSize: 12, color: Colors.green),
              ),
            ),
          if (_typingUsers.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "${_typingUsers.join(", ")} is typing...",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: Text("No messages yet"))
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (_, i) {
                final msg = _messages[i];
                return Align(
                  alignment: msg.isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                      msg.isMe ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: msg.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (!msg.isMe)
                          Text(
                            msg.sender,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          msg.content,
                          style: TextStyle(
                            color:
                            msg.isMe ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: (_) => _sendStartTyping(),
                    decoration: const InputDecoration(
                      hintText: "Message...",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessageWS(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
