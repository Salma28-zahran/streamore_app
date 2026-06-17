import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/apis/live_token%20/bloc/livekit_token_model.dart';
import 'package:streamore_app/core/apis/live_token%20/bloc/livekit_token_states.dart';

class LiveKitTokenCubit extends Cubit<LiveKitTokenState> {
  LiveKitTokenCubit() : super(LiveKitTokenInitial());

  final String baseUrl = "https://apistreamore.genius-ai.net/";

  Future<void> createLiveKitToken({
    required int streamId,
    required int accountId,
    required String name,
    required String description,
    required String layoutType,
    required String csrfToken,
    String? authToken,
  }) async {
    emit(LiveKitTokenLoading());

    try {
      final url = Uri.parse(
        "${baseUrl}api/streams/streams/$streamId/livekit-token/",
      );

      final response = await http.post(
        url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "X-CSRFTOKEN": csrfToken,
          if (authToken != null) "Authorization": "Token $authToken",
        },
        body: jsonEncode({
          "account_id": accountId,
          "name": name,
          "description": description,
          "layout_type": layoutType,
        }),
      );

      final data = jsonDecode(response.body);
      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        emit(LiveKitTokenSuccess(
          LiveKitTokenModel.fromJson(data),
        ));
      } else {
        emit(LiveKitTokenError(
          data['error']?['message'] ?? "Error occurred",
        ));
      }
    } catch (e) {
      emit(LiveKitTokenError(e.toString()));
    }
  }
}