import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/features/live_token%20/bloc/livekit_token_model.dart';

import 'livekit_token_states.dart';

class LiveKitTokenCubit
    extends Cubit<LiveKitTokenStates> {

  LiveKitTokenCubit()
      : super(LiveKitTokenInitialState());

  LiveKitTokenModel? liveKitTokenModel;

  Future<void> getLiveKitToken({
    required int streamId,
  }) async {

    emit(LiveKitTokenLoadingState());

    try {

      final token =
      await StorageHelper.getToken();

      final response = await http.post(
        Uri.parse(
          "https://apistreamore.genius-ai.net/api/streams/streams/$streamId/livekit-token/",
        ),

        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },

        body: jsonEncode({
          "account_id": 0,
          "name": "test stream",
          "description": "test description",
          "layout_type": "user",
        }),
      );

      debugPrint(
        "📡 STATUS CODE => ${response.statusCode}",
      );

      debugPrint(
        "📦 RESPONSE => ${response.body}",
      );

      final data =
      jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {

        liveKitTokenModel =
            LiveKitTokenModel.fromJson(data);

        emit(
          LiveKitTokenSuccessState(),
        );

      } else {

        emit(
          LiveKitTokenErrorState(
            error: data.toString(),
          ),
        );
      }

    } catch (e) {

      emit(
        LiveKitTokenErrorState(
          error: e.toString(),
        ),
      );
    }
  }
}