abstract class SendStates {}

class SendActivateInitialState extends SendStates {}
class SendActivateLoadingState extends SendStates {}

class SendActivateSuccessState extends SendStates {
  final String message;
  SendActivateSuccessState({required this.message});
}

class FailedToSendActivateState extends SendStates {
  final String error;
  FailedToSendActivateState({required this.error});
}