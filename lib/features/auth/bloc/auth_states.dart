abstract class AuthStates{}


class AuthInitialState extends AuthStates{}

class RegisterLoadingState extends AuthStates{}

class RegisterSuccessState extends AuthStates{}

class FailedToRegisterState extends AuthStates{
  String message;
  FailedToRegisterState({required this.message});
}

class ActivateLoadingState extends AuthStates {}

class ActivateSuccessState extends AuthStates {}

class FailedToActivateState extends AuthStates {
  final String message;
  FailedToActivateState({required this.message});
}


class LogInLoadingState extends AuthStates{}

class LogInSuccessState extends AuthStates{}

class FailedToLogInState extends AuthStates{
}




class LogOutLoadingState extends AuthStates {}

class LogOutSuccessState extends AuthStates {
  final String message;
  LogOutSuccessState({required this.message});
}

class FailedToLogOutState extends AuthStates {
  final String error;
  FailedToLogOutState({required this.error});
}












