import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'activate_states.dart';

class ActivateCubit extends Cubit<ActivateStates> {
  ActivateCubit() : super(ActivateInitialState());

  Future<void> activateAccount({
    required String email,
    required int activationCode,
  }) async {
    emit(ActivateLoadingState());

    try {
      print("📩 Sending activation request...");
      print("➡️ email: $email");
      print("➡️ activation_code: $activationCode");

      final response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/activate/"),
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "activation_code": activationCode.toString(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("✅ Activated successfully: $data");
        emit(ActivateSuccessState());
      } else {
        final errorMessage =
            data['message'] ?? data['error'] ?? "Failed to activate account";
        debugPrint("❌ Activation failed: $errorMessage");
        emit(FailedToActivateState(message: errorMessage));
      }
    } catch (e) {
      debugPrint("⚠️ Exception during activation: $e");
      emit(FailedToActivateState(message: e.toString()));
    }
  }
}