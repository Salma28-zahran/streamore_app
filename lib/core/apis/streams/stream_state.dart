
import 'package:streamore_app/core/apis/streams/stream_model.dart';

abstract class StreamState {}

class StreamInitial
    extends StreamState {}

class CreateStreamLoading
    extends StreamState {}

class CreateStreamSuccess
    extends StreamState {
  final StreamModel stream;

  CreateStreamSuccess(
      this.stream,
      );
}

class CreateStreamError
    extends StreamState {
  final String error;

  CreateStreamError(
      this.error,
      );
}