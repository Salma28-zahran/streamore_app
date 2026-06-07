
import 'package:streamore_app/core/apis/stream_des/stream_destinations_model.dart';

abstract class StreamDestinationsState {}

class StreamDestinationsInitial
    extends StreamDestinationsState {}

class StreamDestinationsLoading
    extends StreamDestinationsState {}

class StreamDestinationsSuccess
    extends StreamDestinationsState {
  final StreamDestinationsModel
  model;

  StreamDestinationsSuccess(
      this.model,
      );
}

class StreamDestinationsError
    extends StreamDestinationsState {
  final String error;

  StreamDestinationsError(
      this.error,
      );
}