import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/helpers/storage_helper.dart';
import 'start_stream_model.dart';
import 'start_stream_states.dart';

class StartStreamCubit extends Cubit<StartStreamStates> {
  StartStreamCubit() : super(StartStreamInitialState());

  Future<Map<String, dynamic>> startStream({
    required int streamId,
    required StartStreamModel model,
  }) async {
    try {
      final token = await StorageHelper.getToken();

      final response = await http.post(
        Uri.parse(
          "https://apistreamore.genius-ai.net/api/streams/streams/$streamId/start/",
        ),
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode(model.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        emit(StartStreamSuccessState(message: "Stream started successfully"));

        return data;
      } else {
        throw Exception(
          data["error"]?["message"] ?? "Failed to start stream",
        );
      }
    } catch (e) {
      emit(StartStreamErrorState(error: e.toString()));
      rethrow;
    }
  }
}