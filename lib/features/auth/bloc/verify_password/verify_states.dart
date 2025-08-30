abstract class VerifyStates {}

class VerifyPassCodeInitialState extends VerifyStates {}

class VerifyPassCodeLoadingState extends VerifyStates {}

class VerifyPassCodeSuccessState extends VerifyStates {
  final String message;
  VerifyPassCodeSuccessState({required this.message});
}

class FailedToVerifyPassCodeState extends VerifyStates {
  final String error;
  FailedToVerifyPassCodeState({required this.error});
}
