import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/features/auth/bloc/reset_password/reset_states.dart';


class ResetPasswordCubit extends Cubit<ResetStates> {
  ResetPasswordCubit() : super(ResetPasswordInitialState());

  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoadingState());
    try {
      final response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/resetpassword/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        emit(ResetPasswordSuccessState(
          message: responseBody["message"] ?? "Check your email",
        ));
      } else {
        emit(FailedToResetPasswordState(
          error: responseBody["error"] ?? "Something went wrong",
        ));
      }
    } catch (e) {
      emit(FailedToResetPasswordState(error: e.toString()));
    }
  }
}
