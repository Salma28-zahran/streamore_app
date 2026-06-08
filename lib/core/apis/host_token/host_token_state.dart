
import 'package:streamore_app/core/apis/host_token/host_token_model.dart';

abstract class HostTokenState {}

class HostTokenInitial
    extends HostTokenState {}

class HostTokenLoading
    extends HostTokenState {}

class HostTokenSuccess
    extends HostTokenState {
  final HostTokenModel model;

  HostTokenSuccess(
      this.model,
      );
}

class HostTokenError
    extends HostTokenState {
  final String error;

  HostTokenError(
      this.error,
      );
}