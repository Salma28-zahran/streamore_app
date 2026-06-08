

import 'package:streamore_app/core/apis/connect_des/connect_destination_model.dart';

abstract class ConnectDestinationState {}

class ConnectDestinationInitial
    extends ConnectDestinationState {}

class ConnectDestinationLoading
    extends ConnectDestinationState {}

class ConnectDestinationSuccess
    extends ConnectDestinationState {
  final ConnectDestinationModel model;

  ConnectDestinationSuccess(
      this.model,
      );
}

class ConnectDestinationError
    extends ConnectDestinationState {
  final String error;

  ConnectDestinationError(
      this.error,
      );
}