import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/features/auth/bloc/send_activate/send_states.dart';

class SendActivateCubit extends Cubit<SendStates> {
  SendActivateCubit() : super(SendActivateInitialState());

  void sendActivate({required String email}) async {
    emit(SendActivateLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/sendactivate/"),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ SendActivate success: $responseBody");
        emit(SendActivateSuccessState(
            message: responseBody["Message"] ??
                "Activation code sent successfully"));
      } else {
        debugPrint("❌ SendActivate failed: $responseBody");
        final errorMessage =
            responseBody['message'] ?? responseBody['error'] ?? "Unknown error";
        emit(FailedToSendActivateState(error: errorMessage));
      }
    } catch (e) {
      emit(FailedToSendActivateState(error: e.toString()));
    }
  }
}