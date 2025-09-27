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