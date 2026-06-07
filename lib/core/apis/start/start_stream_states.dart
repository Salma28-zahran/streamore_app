abstract class StartStreamStates {}

class StartStreamInitialState extends StartStreamStates {}

class StartStreamLoadingState extends StartStreamStates {}

class StartStreamSuccessState extends StartStreamStates {
  final String message;

  StartStreamSuccessState({
    required this.message,
  });
}

class StartStreamErrorState extends StartStreamStates {
  final String error;

  StartStreamErrorState({
    required this.error,
  });
}