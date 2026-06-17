import 'package:streamore_app/core/apis/start/start_stream_model.dart';

abstract class StartStreamStates {}

class StartStreamInitialState extends StartStreamStates {}

class StartStreamLoadingState extends StartStreamStates {}

class StartStreamSuccessState extends StartStreamStates {
  final StartStreamModel data;

  StartStreamSuccessState({
    required this.data,
  });
}

class StartStreamErrorState extends StartStreamStates {
  final String error;

  StartStreamErrorState({
    required this.error,
  });
}