import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/apis/destination/DestinationModel.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

part 'destination_state.dart';

class DestinationCubit extends Cubit<DestinationState> {
  DestinationCubit() : super(DestinationInitial());

  static DestinationCubit get(context) =>
      BlocProvider.of(context);

  Future<DestinationModel?> createDestination({
    required String name,
    required String platformType,
    required String rtmpUrl,
    required String rtmpKey,
    required String streamUrl,
  }) async {
    emit(CreateDestinationLoading());

    print("\n====================");
    print("🚀 CREATE DESTINATION START");
    print("====================");

    try {
      final token = await StorageHelper.getToken();

      print("🔑 TOKEN => $token");

      final body = {
        "name": name,
        "platform_type": platformType,
        "rtmp_url": rtmpUrl,
        "rtmp_key": rtmpKey,
        "stream_url": streamUrl,
      };

      print("📦 REQUEST BODY => $body");

      final response = await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/destinations/',
        ),
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode(body),
      );

      print("📡 STATUS CODE => ${response.statusCode}");
      print("📡 RESPONSE BODY => ${response.body}");

      dynamic data;

      try {
        data = jsonDecode(response.body);
        print("📦 DECODED JSON => $data");
      } catch (e) {
        print("❌ JSON DECODE FAILED => $e");
        print("RAW BODY => ${response.body}");
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final destination = DestinationModel.fromJson(data);

          print("✅ DESTINATION PARSED SUCCESS");
          print("ID => ${destination.id}");

          emit(CreateDestinationSuccess(destination));
          return destination;
        } catch (e) {
          print("❌ MODEL PARSING FAILED => $e");
          emit(CreateDestinationError("Model parsing failed"));
          return null;
        }
      } else {
        print("❌ API ERROR STATUS => ${response.statusCode}");
        print("❌ ERROR BODY => ${response.body}");

        emit(
          CreateDestinationError(
            (data is Map)
                ? (data["error"]?["message"]?.toString() ?? "Unknown error")
                : "Invalid response format",
          ),
        );

        return null;
      }
    } catch (e, stack) {
      print("🔥 EXCEPTION OCCURRED");
      print("ERROR => $e");
      print("STACK => $stack");

      emit(CreateDestinationError(e.toString()));
      return null;
    }
  }
}