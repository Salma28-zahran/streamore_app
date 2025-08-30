abstract class DoneStates {}

class ResetPassDoneInitialState extends DoneStates {}

class ResetPassDoneLoadingState extends DoneStates {}

class ResetPassDoneSuccessState extends DoneStates {
  final String message;
  ResetPassDoneSuccessState({required this.message});
}

class FailedToResetPassDoneState extends DoneStates {
  final String error;
  FailedToResetPassDoneState({required this.error});
}
