import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/core/services/chat_service.dart';
import 'package:streamore_app/features/tabs/chat/bloc/chat_websockets_manager.dart'
    show ChatWebsocketManager;
import 'package:streamore_app/features/tabs/chat/widgets/TypingIndicator.dart';

/// Model for a chat message
class ChatMessage {
  final int? id;
  final int? chatId;
  final int? senderId;
  final String sender;
  final String content;
  final String? timestamp;
  final bool isMe;
  final bool isMedia;

  ChatMessage({
    this.id,
    this.chatId,
    this.senderId,
    required this.sender,
    required this.content,
    this.timestamp,
    this.isMe = false,
    this.isMedia = false,
  });

  /// Accepts different shapes from server for `sender`:
  /// - sender could be Map { id, username }
  /// - or sender could be a plain string
  factory ChatMessage.fromJson(
      Map<String, dynamic> json, {
        int? currentUserId,
        String? currentUserName,
      }) {
    int? senderId;
    String senderName = 'unknown';

    final s = json['sender'];
    if (s is Map) {
      senderId = s['id'] is int ? s['id'] as int : (int.tryParse('${s['id']}'));
      senderName = (s['username'] ?? s['name'] ?? senderId?.toString())?.toString() ?? 'unknown';
    } else if (s != null) {
      senderName = s.toString();
    } else if (json['sender_username'] != null) {
      senderName = json['sender_username'].toString();
    }

    bool isMe = false;
    if (currentUserId != null && senderId != null) {
      isMe = currentUserId == senderId;
    } else if (currentUserName != null) {
      isMe = senderName == currentUserName;
    }

    return ChatMessage(
      id: json['id'] is int ? json['id'] as int : (int.tryParse('${json['id']}')),
      chatId: json['chat'] is int ? json['chat'] as int : (int.tryParse('${json['chat']}')),
      senderId: senderId,
      sender: senderName,
      content: json['content']?.toString() ?? '',
      timestamp: json['timestamp']?.toString(),
      isMe: isMe,
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
  int? _myUserId;
  int _chatId = 0;
  late String currentUser;

  StreamSubscription? _sub;
  List<String> _typingUsers = [];
  Map<String, Timer> _typingTimers = {};
  List<String> _activeUsers = [];

  Timer? _localTypingTimer;
  bool _isTypingLocally = false;

  @override
  void initState() {
    super.initState();
    _initSetup();
  }

  Future<void> _initSetup() async {
    _token = await StorageHelper.getToken();
    _email = await StorageHelper.getEmail();
    final myUserId = await StorageHelper.getUserId(); // expecting int
    if (_token == null || _email == null || myUserId == null) {
      print("⚠️ Missing auth data — cannot start chat");
      return;
    }

    _myUserId = myUserId;
    currentUser = _email!.split('@')[0];

    // --- create or get chat (example) ---
    final newChat = await ChatService.createChat(
      _token!,
      userIds: [21], // replace with real other participants (exclude self)
      isGroup: true,
      name: "Study Group",
    );

    print("DEBUG createChat response: $newChat");

    if (newChat != null) {
      if (newChat['id'] != null) {
        _chatId = newChat['id'] as int;
      } else if (newChat['chat'] != null && newChat['chat']['id'] != null) {
        _chatId = newChat['chat']['id'] as int;
      } else {
        print("⚠️ createChat returned unexpected shape: $newChat");
      }
    } else {
      print("⚠️ createChat returned null");
    }

    if (_chatId == 0) {
      print("⚠️ No valid chatId — skipping websocket connect");
      return;
    }

    // load history first (optional)
    await _loadHistory();

    // connect websocket (use the corrected ChatWebsocketManager)
    ChatWebsocketManager.instance.connect(token: _token!, chatId: _chatId);

    _sub = ChatWebsocketManager.instance.stream.listen(_handleSocketEvent);

    setState(() {});
  }

  Future<void> _loadHistory() async {
    if (_token == null || _chatId == 0) return;
    try {
      final history = await ChatService.getChatMessages(token: _token!, chatId: _chatId);
      setState(() {
        _messages.clear();
        _messages.addAll(history.map((j) => ChatMessage.fromJson(
          j,
          currentUserId: _myUserId,
          currentUserName: currentUser,
        )));
      });
      // scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      print("❌ loadHistory error: $e");
    }
  }

  void _handleSocketEvent(Map<String, dynamic> data) {
    // Expect server events: "message", "typing", "seen", "user_status"
    print("📥 WS Event received: $data");
    final type = data['type']?.toString() ?? '';

    switch (type) {
      case 'message':
      // server should send full message object
        try {
          final msg = ChatMessage.fromJson(data, currentUserId: _myUserId, currentUserName: currentUser);

          setState(() {
            // dedupe by id (if id present)
            if (msg.id != null) {
              if (!_messages.any((m) => m.id == msg.id)) {
                _messages.add(msg);
              } else {
                // optionally update existing message (seen_by etc.)
                final idx = _messages.indexWhere((m) => m.id == msg.id);
                if (idx != -1) _messages[idx] = msg;
              }
            } else {
              // message without id: add but try to avoid exact duplicates
              if (!_messages.any((m) => m.content == msg.content && m.sender == msg.sender && m.timestamp == msg.timestamp)) {
                _messages.add(msg);
              }
            }

            // remove sender from typing list (if present)
            _removeTypingUser(msg.sender);
          });

          // scroll to bottom
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          });
        } catch (e) {
          print("❌ Error parsing message event: $e");
        }
        break;

      case 'typing':
        final username = (data['username'] ?? data['user'] ?? '').toString();
        if (username.isEmpty) return;
        if (username == currentUser) return; // ignore own typing indicator
        _addOrRefreshTypingUser(username);
        break;

      case 'seen':
      // optional: handle seen updates (update local message's seen_by if you store it)
      // server payload example: { type: "seen", message_ids: [...], by: { id, username } }
        print("👀 seen event: $data");
        break;

      case 'user_status':
        final users = List<String>.from(data['active_users'] ?? []);
        setState(() => _activeUsers = users);
        break;

      default:
        print("ℹ️ Other/unknown event: $data");
    }
  }

  void _addOrRefreshTypingUser(String username) {
    // cancel old timer if present
    _typingTimers[username]?.cancel();

    setState(() {
      if (!_typingUsers.contains(username)) _typingUsers.add(username);
    });

    // remove after 3s of inactivity
    _typingTimers[username] = Timer(const Duration(seconds: 3), () {
      _removeTypingUser(username);
    });
  }

  void _removeTypingUser(String username) {
    _typingTimers[username]?.cancel();
    _typingTimers.remove(username);
    setState(() {
      _typingUsers.remove(username);
    });
  }

  void _sendMessageWS(String text) {
    if (text.trim().isEmpty) return;
    if (_myUserId == null) {
      print("❌ myUserId is null; cannot send WS message");
      return;
    }

    try {
      // Use manager's sendMessage to send well-formed WS event
      ChatWebsocketManager.instance.sendMessage(
        senderId: _myUserId!,
        content: text,
      );
      print("📤 Sent WS message: $text");
    } catch (e) {
      print("❌ Error sending message: $e");
    }

    // clear input and reset typing state
    _controller.clear();
    _localTypingTimer?.cancel();
    _isTypingLocally = false;
  }

  void _onTextChanged(String _) {
    // debounce sending typing event — send one event then wait 3s of inactivity
    _localTypingTimer?.cancel();
    if (!_isTypingLocally) {
      // send a single typing event (server clients will remove after timeout)
      ChatWebsocketManager.instance.sendTyping(currentUser);
      _isTypingLocally = true;
    }
    _localTypingTimer = Timer(const Duration(seconds: 3), () {
      _isTypingLocally = false;
      // we don't send a "stop typing" event because server's clients remove typing after timeout,
      // if your server expects explicit stop event you can call a sendTypingStop method here.
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    ChatWebsocketManager.instance.disconnect();
    _controller.dispose();
    _scrollController.dispose();
    _localTypingTimer?.cancel();
    for (final t in _typingTimers.values) {
      t.cancel();
    }
    _typingTimers.clear();
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
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TypingIndicator(),
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
                  alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg.isMe ? Colors.blue : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(maxWidth: 320),
                    child: Column(
                      crossAxisAlignment: msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!msg.isMe)
                          Text(
                            msg.sender,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          msg.content,
                          style: TextStyle(color: msg.isMe ? Colors.white : Colors.black),
                        ),
                        if (msg.timestamp != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            DateFormat.Hm().format(DateTime.parse(msg.timestamp!)),
                            style: TextStyle(
                              fontSize: 10,
                              color: msg.isMe ? Colors.white : Colors.blue,
                            ),
                          ),



                        ],
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
                    onChanged: (v) {
                      _onTextChanged(v);
                    },
                    decoration: const InputDecoration(
                      hintText: "Message...",
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (val) {
                      final text = val.trim();
                      if (text.isEmpty) return;
                      _sendMessageWS(text);
                    },
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
