import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/apis/connect_des/connect_destination_state.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

import 'connect_destination_model.dart';


class ConnectDestinationCubit
    extends Cubit<ConnectDestinationState> {
  ConnectDestinationCubit()
      : super(
    ConnectDestinationInitial(),
  );

  static ConnectDestinationCubit get(
      context,
      ) =>
      BlocProvider.of(context);

  Future<void> connectDestination({
    required int destinationId,
    required int accountId,
    required String name,
    required String platformType,
    required String rtmpKey,
    required String streamUrl,
  }) async {
    emit(
      ConnectDestinationLoading(),
    );

    try {
      final token =
      await StorageHelper.getToken();

      final response =
      await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/destinations/$destinationId/connect/',
        ),
        headers: {
          "accept":
          "application/json",
          "Content-Type":
          "application/json",

          /// لو backend عندكم Bearer
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

      final data = jsonDecode(
        response.body,
      );

      if (response.statusCode ==
          200 ||
          response.statusCode ==
              201) {
        emit(
          ConnectDestinationSuccess(
            ConnectDestinationModel
                .fromJson(data),
          ),
        );
      } else {
        emit(
          ConnectDestinationError(
            data["error"]
            ?["message"] ??
                "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(
        ConnectDestinationError(
          e.toString(),
        ),
      );
    }
  }
}