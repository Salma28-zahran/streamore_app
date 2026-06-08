
import 'package:streamore_app/core/apis/disconnect_des/disconnect_destination_model.dart';

abstract class DisconnectDestinationState {}

class DisconnectDestinationInitial
    extends DisconnectDestinationState {}

class DisconnectDestinationLoading
    extends DisconnectDestinationState {}

class DisconnectDestinationSuccess
    extends DisconnectDestinationState {
  final DisconnectDestinationModel
  model;

  DisconnectDestinationSuccess(
      this.model,
      );
}

class DisconnectDestinationError
    extends DisconnectDestinationState {
  final String error;

  DisconnectDestinationError(
      this.error,
      );
}