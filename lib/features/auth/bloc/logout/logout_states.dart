abstract class LogoutStates {}

class LogOutInitialState extends LogoutStates {}
class LogOutLoadingState extends LogoutStates {}

class LogOutSuccessState extends LogoutStates {
  final String message;
  LogOutSuccessState({required this.message});
}

class FailedToLogOutState extends LogoutStates {
  final String error;
  FailedToLogOutState({required this.error});
}