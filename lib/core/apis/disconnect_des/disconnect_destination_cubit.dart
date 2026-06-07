import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'
as http;
import 'package:streamore_app/core/apis/disconnect_des/disconnect_destination_state.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

import 'disconnect_destination_model.dart';


class DisconnectDestinationCubit
    extends Cubit<
        DisconnectDestinationState> {
  DisconnectDestinationCubit()
      : super(
    DisconnectDestinationInitial(),
  );

  static DisconnectDestinationCubit
  get(context) =>
      BlocProvider.of(context);

  Future<void>
  disconnectDestination({
    required int id,
    required int accountId,
    required String name,
    required String platformType,
    required String rtmpKey,
    required String streamUrl,
  }) async {
    emit(
      DisconnectDestinationLoading(),
    );

    try {
      final token =
      await StorageHelper.getToken();

      final response =
      await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/destinations/$id/disconnect/',
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
          "platform_type":
          platformType,
          "rtmp_key":
          rtmpKey,
          "stream_url":
          streamUrl,
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
          DisconnectDestinationSuccess(
            DisconnectDestinationModel
                .fromJson(
              data,
            ),
          ),
        );
      } else {
        emit(
          DisconnectDestinationError(
            data["error"]
            ?["message"] ??
                "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(
        DisconnectDestinationError(
          e.toString(),
        ),
      );
    }
  }
}