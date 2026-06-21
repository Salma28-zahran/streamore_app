import 'package:streamore_app/core/apis/live_token%20/bloc/livekit_token_model.dart';

abstract class LiveKitTokenState {}

class LiveKitTokenInitial extends LiveKitTokenState {}

class LiveKitTokenLoading extends LiveKitTokenState {}

class LiveKitTokenSuccess extends LiveKitTokenState {
  final LiveKitTokenModel data;
  LiveKitTokenSuccess(this.data);
}

class LiveKitTokenError extends LiveKitTokenState {
  final String message;
  LiveKitTokenError(this.message);
}