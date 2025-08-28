abstract class ResetStates {}

class ResetPasswordInitialState extends ResetStates {}
class ResetPasswordLoadingState extends ResetStates {}

class ResetPasswordSuccessState extends ResetStates {
  final String message;
  ResetPasswordSuccessState({required this.message});
}

class FailedToResetPasswordState extends ResetStates {
  final String error;
  FailedToResetPasswordState({required this.error});
}