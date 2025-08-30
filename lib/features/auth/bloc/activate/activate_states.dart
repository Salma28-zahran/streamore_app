abstract class ActivateStates {}

class ActivateInitialState extends ActivateStates {}
class ActivateLoadingState extends ActivateStates {}
class ActivateSuccessState extends ActivateStates {}

class FailedToActivateState extends ActivateStates {
  final String message;
  FailedToActivateState({required this.message});
}