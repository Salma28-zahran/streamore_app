import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'
as http;
import 'package:streamore_app/core/apis/stream_des/stream_destinations_state.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

import 'stream_destinations_model.dart';


class StreamDestinationsCubit
    extends Cubit<
        StreamDestinationsState> {
  StreamDestinationsCubit()
      : super(
    StreamDestinationsInitial(),
  );

  static StreamDestinationsCubit
  get(context) =>
      BlocProvider.of(context);

  Future<void>
  getStreamDestinations({
    required int id,
    required int accountId,
    required String name,
    required String description,
    required String layoutType,
  }) async {
    emit(
      StreamDestinationsLoading(),
    );

    try {
      final token =
      await StorageHelper.getToken();

      final response =
      await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/streams/$id/destinations/',
        ),
        headers: {
          "accept":
          "application/json",
          "Content-Type":
          "application/json",
          "Authorization":
          "Bearer $token",
        },
        body: jsonEncode({
          "account_id":
          accountId,
          "name": name,
          "description":
          description,
          "layout_type":
          layoutType,
        }),
      );

      final data =
      jsonDecode(
        response.body,
      );

      if (response.statusCode ==
          200 ||
          response.statusCode ==
              201) {
        emit(
          StreamDestinationsSuccess(
            StreamDestinationsModel
                .fromJson(
              data,
            ),
          ),
        );
      } else {
        emit(
          StreamDestinationsError(
            data["error"]
            ?["message"] ??
                "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(
        StreamDestinationsError(
          e.toString(),
        ),
      );
    }
  }
}