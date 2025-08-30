abstract class RegisterStates {}

class RegisterInitialState extends RegisterStates {}
class RegisterLoadingState extends RegisterStates {}
class RegisterSuccessState extends RegisterStates {}

class FailedToRegisterState extends RegisterStates {
  final String message;
  FailedToRegisterState({required this.message});
}