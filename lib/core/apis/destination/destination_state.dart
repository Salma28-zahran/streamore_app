part of 'destination_cubit.dart';

abstract class DestinationState {}

class DestinationInitial extends DestinationState {}

class CreateDestinationLoading extends DestinationState {}

class CreateDestinationSuccess extends DestinationState {
  final DestinationModel destination;

  CreateDestinationSuccess(this.destination);
}

class CreateDestinationError extends DestinationState {
  final String error;

  CreateDestinationError(this.error);
}