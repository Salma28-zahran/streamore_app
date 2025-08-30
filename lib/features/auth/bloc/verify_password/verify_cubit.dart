import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'verify_states.dart';

class VerifyCubit extends Cubit<VerifyStates> {
  VerifyCubit() : super(VerifyPassCodeInitialState());

  Future<void> verifyPassCode({
    required String email,
    required String code,
  }) async {
    emit(VerifyPassCodeLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/resetpassword-verify/"),
        body: {
          "email": email,
          "reset_code": code,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(VerifyPassCodeSuccessState(
          message: data["message"] ?? "Code Verified",
        ));
      } else {
        final error = json.decode(response.body)["error"] ?? "Failed to verify code";
        emit(FailedToVerifyPassCodeState(error: error));
      }
    } catch (e) {
      emit(FailedToVerifyPassCodeState(error: e.toString()));
    }
  }
}
