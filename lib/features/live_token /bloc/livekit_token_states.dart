abstract class LiveKitTokenStates {}

class LiveKitTokenInitialState
    extends LiveKitTokenStates {}

class LiveKitTokenLoadingState
    extends LiveKitTokenStates {}

class LiveKitTokenSuccessState
    extends LiveKitTokenStates {}

class LiveKitTokenErrorState
    extends LiveKitTokenStates {

  final String error;

  LiveKitTokenErrorState({
    required this.error,
  });
}