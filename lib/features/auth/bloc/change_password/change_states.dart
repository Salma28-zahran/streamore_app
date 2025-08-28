abstract class ChangePasswordStates {}

class ChangePasswordInitialState extends ChangePasswordStates {}

class ChangePasswordLoadingState extends ChangePasswordStates {}

class ChangePasswordSuccessState extends ChangePasswordStates {
  final String message;
  ChangePasswordSuccessState({required this.message});
}

class FailedToChangePasswordState extends ChangePasswordStates {
  final String error;
  FailedToChangePasswordState({required this.error});
}
