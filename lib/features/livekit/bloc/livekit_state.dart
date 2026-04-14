import 'package:livekit_client/livekit_client.dart';

abstract class LiveKitState {}

class LiveKitInitial extends LiveKitState {}

class LiveKitLoading extends LiveKitState {}

class LiveKitConnected extends LiveKitState {
  final List<Participant> participants;
  final LocalParticipant? localParticipant;
  final bool isMuted;
  final bool isCameraOff;

  LiveKitConnected({
    required this.participants,
    this.localParticipant,
    required this.isMuted,
    required this.isCameraOff,
  });

  LiveKitConnected copyWith({
    List<Participant>? participants,
    LocalParticipant? localParticipant,
    bool? isMuted,
    bool? isCameraOff,
  }) {
    return LiveKitConnected(
      participants: participants ?? this.participants,
      localParticipant: localParticipant ?? this.localParticipant,
      isMuted: isMuted ?? this.isMuted,
      isCameraOff: isCameraOff ?? this.isCameraOff,
    );
  }
}

class LiveKitError extends LiveKitState {
  final String message;

  LiveKitError(this.message);
}