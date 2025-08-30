import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'change_states.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit() : super(ChangePasswordInitialState());

  Future<void> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    try {
      final response = await http.put(
        Uri.parse("http://34.39.27.45:8000/api/users/change-password/"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "old_password": oldPassword,
          "new_password": newPassword,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(ChangePasswordSuccessState(
          message: responseBody["message"] ??
              responseBody["detail"] ??
              "Password changed successfully",
        ));
      } else {
        emit(FailedToChangePasswordState(
          error: responseBody["error"] ??
              responseBody["detail"] ??
              "Failed to change password",
        ));
      }
    } catch (e) {
      emit(FailedToChangePasswordState(error: e.toString()));
    }
  }
}
