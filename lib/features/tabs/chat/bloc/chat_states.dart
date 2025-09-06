// chat_state.dart
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}
class ChatConnecting extends ChatState {}
class ChatConnected extends ChatState {}
class ChatDisconnected extends ChatState {}
class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}

class ChatMessageReceived extends ChatState {
  final List<Map<String, dynamic>> messages;
  const ChatMessageReceived(this.messages);
  @override
  List<Object?> get props => [messages];
}

class ChatTypingUsersUpdated extends ChatState {
  final List<String> typingUsers;
  const ChatTypingUsersUpdated(this.typingUsers);
  @override
  List<Object?> get props => [typingUsers];
}

class ChatActiveUsersUpdated extends ChatState {
  final List<String> activeUsers;
  const ChatActiveUsersUpdated(this.activeUsers);
  @override
  List<Object?> get props => [activeUsers];
}
