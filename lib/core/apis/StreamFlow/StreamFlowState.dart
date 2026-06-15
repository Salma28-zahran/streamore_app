abstract class StreamFlowState {}

class StreamFlowInitial extends StreamFlowState {}

class StreamFlowLoading extends StreamFlowState {}

class StreamFlowSuccess extends StreamFlowState {
  final String message;
  StreamFlowSuccess(this.message);
}

class StreamFlowError extends StreamFlowState {
  final String error;
  StreamFlowError(this.error);
}