abstract class AuthStates{}


class AuthInitialState extends AuthStates{}

class RegisterLoadingState extends AuthStates{}

class RegisterSuccessState extends AuthStates{}

class FailedToRegisterState extends AuthStates{
  String message;
  FailedToRegisterState({required this.message});
}

class ActivateLoadingState extends AuthStates {}

class ActivateSuccessState extends AuthStates {
  final String message;
  ActivateSuccessState({this.message = "Account activated successfully"});
}

class FailedToActivateState extends AuthStates {
  final String message;
  FailedToActivateState({required this.message});
}


class LogInLoadingState extends AuthStates{}

class LogInSuccessState extends AuthStates{}

class FailedToLogInState extends AuthStates{
}



class SendActivateLoadingState extends AuthStates {}

class SendActivateSuccessState extends AuthStates {
  final String message;
  SendActivateSuccessState({required this.message});
}

class FailedToSendActivateState extends AuthStates {
  final String error;
  FailedToSendActivateState({required this.error});
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




class ResetPasswordLoadingState extends AuthStates {}

class ResetPasswordSuccessState extends AuthStates {
  final String message;
  ResetPasswordSuccessState({required this.message});
}

class FailedToResetPasswordState extends AuthStates {
  final String error;
  FailedToResetPasswordState({required this.error});
}


class VerifyPassCodeLoadingState extends AuthStates {}

class VerifyPassCodeSuccessState extends AuthStates {
  final String message;
  VerifyPassCodeSuccessState({required this.message});
}

class FailedToVerifyPassCodeState extends AuthStates {
  final String error;
  FailedToVerifyPassCodeState({required this.error});
}




class ResetPassDoneLoadingState extends AuthStates {}

class ResetPassDoneSuccessState extends AuthStates {
  final String message;
  ResetPassDoneSuccessState({required this.message});
}

class FailedToResetPassDoneState extends AuthStates {
  final String error;
  FailedToResetPassDoneState({required this.error});
}




class ChangePasswordLoadingState extends AuthStates {}

class ChangePasswordSuccessState extends AuthStates {
  final String message;
  ChangePasswordSuccessState({required this.message});
}

class FailedToChangePasswordState extends AuthStates {
  final String error;
  FailedToChangePasswordState({required this.error});
}













