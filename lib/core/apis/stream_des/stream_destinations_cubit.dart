import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/apis/stream_des/stream_destinations_state.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

import 'stream_destinations_model.dart';

class StreamDestinationsCubit extends Cubit<StreamDestinationsState> {
  StreamDestinationsCubit()
      : super(
    StreamDestinationsInitial(),
  );

  static StreamDestinationsCubit get(context) =>
      BlocProvider.of(context);

  Future<StreamDestinationsModel?> attachDestination({
    required int streamId,
    required int destinationId,
  }) async {
    emit(StreamDestinationsLoading());

    try {
      final token =
      await StorageHelper.getToken();

      final response =
      await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/streams/$streamId/destinations/',
        ),
        headers: {
          "accept": "application/json",
          "Content-Type":
          "application/json",
          "Authorization":
          "Token $token",
        },
        body: jsonEncode({
          "destination_id":
          destinationId,
        }),
      );

      final data =
      jsonDecode(response.body);

      if (response.statusCode ==
          200 ||
          response.statusCode ==
              201) {
        final model =
        StreamDestinationsModel
            .fromJson(data);

        emit(
          StreamDestinationsSuccess(
            model,
          ),
        );

        return model;
      } else {
        emit(
          StreamDestinationsError(
            data["error"]
            ?["message"] ??
                "Something went wrong",
          ),
        );

        return null;
      }
    } catch (e) {
      emit(
        StreamDestinationsError(
          e.toString(),
        ),
      );

      return null;
    }
  }
}