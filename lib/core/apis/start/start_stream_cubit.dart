import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../core/helpers/storage_helper.dart';
import 'start_stream_model.dart';
import 'start_stream_states.dart';

class StartStreamCubit extends Cubit<StartStreamStates> {
  StartStreamCubit() : super(StartStreamInitialState());

  Future<StartStreamModel?> startStream({
    required int streamId,
    required StartStreamModel model,
  }) async {
    emit(StartStreamLoadingState());

    try {
      final token = await StorageHelper.getToken();

      if (token == null || token.trim().isEmpty) {
        emit(
          StartStreamErrorState(
            error: "Authentication token is empty",
          ),
        );

        return null;
      }

      final url = Uri.parse(
        "https://apistreamore.genius-ai.net/"
            "api/streams/streams/$streamId/start/",
      );

      final requestBody = model.toJson();

      print("");
      print("======================================");
      print("🚀 START STREAM REQUEST");
      print("======================================");

      print("📺 STREAM ID => $streamId");
      print("🌍 START URL => $url");
      print("📦 START REQUEST BODY => $requestBody");

      final response = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token ${token.trim()}",
        },
        body: jsonEncode(requestBody),
      );

      print("📡 START STATUS => ${response.statusCode}");
      print("📡 START BODY => ${response.body}");

      dynamic decodedData;

      try {
        decodedData = jsonDecode(response.body);
      } catch (e) {
        print("❌ START RESPONSE IS NOT VALID JSON => $e");

        emit(
          StartStreamErrorState(
            error:
            "Invalid response from start stream endpoint",
          ),
        );

        return null;
      }

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (decodedData is! Map<String, dynamic>) {
          emit(
            StartStreamErrorState(
              error: "Unexpected start stream response format",
            ),
          );

          return null;
        }

        final stream = StartStreamModel.fromJson(
          decodedData,
        );

        print("✅ STREAM STARTED SUCCESSFULLY");
        print("📺 STREAM STATUS => ${stream.status}");
        print("🟢 IS ACTIVE => ${stream.isActive}");

        emit(
          StartStreamSuccessState(
            data: stream,
          ),
        );

        return stream;
      }

      String errorMessage = "Failed to start stream";

      if (decodedData is Map<String, dynamic>) {
        final error = decodedData["error"];

        if (error is Map<String, dynamic>) {
          errorMessage =
              error["message"]?.toString() ??
                  errorMessage;

          final details = error["details"];

          if (details != null) {
            print("❌ START ERROR DETAILS => $details");
          }

          print(
            "❌ START ERROR CODE => ${error["code"]}",
          );
        } else if (error != null) {
          errorMessage = error.toString();
        } else if (decodedData["message"] != null) {
          errorMessage =
              decodedData["message"].toString();
        }
      }

      print("❌ START STREAM FAILED");
      print("❌ ERROR MESSAGE => $errorMessage");

      emit(
        StartStreamErrorState(
          error: errorMessage,
        ),
      );

      return null;
    } catch (e, stackTrace) {
      print("");
      print("======================================");
      print("❌ START STREAM EXCEPTION");
      print("======================================");
      print("❌ ERROR => $e");
      print("📚 STACK TRACE => $stackTrace");

      emit(
        StartStreamErrorState(
          error: e.toString(),
        ),
      );

      return null;
    }
  }
}