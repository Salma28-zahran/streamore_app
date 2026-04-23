abstract class InviteState {}

class InviteInitial extends InviteState {}

class InviteLoading extends InviteState {}

class InviteLoaded extends InviteState {
  final String streamName;
  final int participants;

  InviteLoaded({
    required this.streamName,
    required this.participants,
  });
}

class InviteError extends InviteState {
  final String message;

  InviteError(this.message);
}
class InviteJoinSuccess extends InviteState {
  final String liveKitToken;

  InviteJoinSuccess(this.liveKitToken);
}