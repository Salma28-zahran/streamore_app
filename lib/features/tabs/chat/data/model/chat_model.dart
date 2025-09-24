class ChatMessage {
  final int senderId;
  final String senderName;
  final String content;
  final String? timestamp;
  final bool isMe;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.content,
    this.timestamp,
    this.isMe = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'sender_id': senderId,
      'sender_name': senderName,
      'content': content,
      'timestamp': timestamp,
      'isMe': isMe,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json, int currentUserId) {
    final sender = json['sender'] ?? {'id': 0, 'username': 'Unknown'};
    return ChatMessage(
      senderId: sender['id'] ?? 0,
      senderName: sender['username'] ?? 'Unknown',
      content: json['content'] ?? '',
      timestamp: json['timestamp'],
      isMe: sender['id'] == currentUserId,
    );
  }
}
