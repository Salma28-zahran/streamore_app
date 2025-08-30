abstract class LoginStates {}

class LogInInitialState extends LoginStates {}
class LogInLoadingState extends LoginStates {}
class LogInSuccessState extends LoginStates {}
class FailedToLogInState extends LoginStates {}