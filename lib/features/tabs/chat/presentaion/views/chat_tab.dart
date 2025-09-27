import 'dart:async';
import 'package:flutter/material.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/core/services/chat_service.dart';
import 'package:streamore_app/features/tabs/chat/bloc/chat_websockets_manager.dart'
    show ChatWebsocketManager;

class ChatMessage {
  final int? id;
  final int? chatId;
  final String sender;
  final String content;
  final String? timestamp;
  final bool isMe;
  final bool isMedia;

  ChatMessage({
    this.id,
    this.chatId,
    required this.sender,
    required this.content,
    this.timestamp,
    this.isMe = false,
    this.isMedia = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json,
      {String? currentUser}) {
    final senderName = json['sender'] is Map
        ? json['sender']['username']
        : (json['sender']?.toString() ?? 'unknown');

    return ChatMessage(
      id: json['id'],
      chatId: json['chat'],
      sender: senderName,
      content: json['content'] ?? '',
      timestamp: json['timestamp']?.toString(),
      isMe: currentUser != null && senderName == currentUser,
      isMedia: json['media'] != null,
    );
  }
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _email;
  String? _token;
  int _chatId = 0;
  late String currentUser;

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
    if (_token == null || _email == null || myUserId == null) return;

    currentUser = _email!.split('@')[0];

    final newChat = await ChatService.createChat(
      _token!,
      userIds: [myUserId, 21],
      isGroup: true,
      name: "Study Group",
    );

    if (newChat != null &&
        newChat['chat'] != null &&
        newChat['chat']['id'] != null) {
      _chatId = newChat['chat']['id'] as int;
    }

    ChatWebsocketManager.instance.connect(
      token: _token!,
      chatId: _chatId,
    );

    print("🔑 Token: $_token, ChatId: $_chatId, CurrentUser: $currentUser");

    _sub = ChatWebsocketManager.instance.stream.listen(_handleSocketEvent);

    setState(() {});
  }

  void _handleSocketEvent(Map<String, dynamic> data) {
    print("📥 WS Event received: $data");
    final type = data['type'];
    switch (type) {
      case 'chat_message':
        final msg = ChatMessage.fromJson(data, currentUser: currentUser);

        setState(() {
          if (!_messages.any((m) => m.id == msg.id)) {
            _messages.add(msg);
            _typingUsers.remove(msg.sender);
          }
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        });
        break;

      case 'typing_update':
        final user = data['user'] as String? ?? "";
        final isTyping = data['is_typing'] == true;
        setState(() {
          if (isTyping && !_typingUsers.contains(user) && user != currentUser) {
            _typingUsers.add(user);
          } else {
            _typingUsers.remove(user);
          }
        });
        break;

      case 'user_status':
      case 'user_status_update':
        final users = List<String>.from(data['active_users'] ?? []);
        setState(() => _activeUsers = users);
        break;

      default:
        print("ℹ️ Other event: $data");
    }
  }

  void _sendMessageWS(String text) {
    if (text.trim().isEmpty ) return;

    try {
      ChatWebsocketManager.instance.sendWS({
        "type": "message",
        "sender_id": 4,
        "content": "t",
      });
    } catch (e) {
      print("❌ Error sending message: $e");
    }

    _controller.clear();
    _sendStopTyping();
  }

  void _sendStartTyping() {
    if (_isTyping) return;
    ChatWebsocketManager.instance.sendWS({
      'type': 'typing_update',
      'chat_id': _chatId,
      'is_typing': true,
    });
    _isTyping = true;
  }

  void _sendStopTyping() {
    if (!_isTyping) return;
    ChatWebsocketManager.instance.sendWS({
      'type': 'typing_update',
      'chat_id': _chatId,
      'is_typing': false,
    });
    _isTyping = false;
  }

  void _resetTypingTimer() {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), _sendStopTyping);
  }

  @override
  void dispose() {
    _sub?.cancel();
    ChatWebsocketManager.instance.disconnect();
    _controller.dispose();
    _scrollController.dispose();
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
              controller: _scrollController,
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
                      color: msg.isMe
                          ? Colors.blue
                          : Colors.grey.shade200,
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
                            color: msg.isMe
                                ? Colors.white
                                : Colors.black,
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
                    onChanged: (_) {
                      _sendStartTyping();
                      _resetTypingTimer();
                    },
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
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isEmpty) return;
                    _sendMessageWS(text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
