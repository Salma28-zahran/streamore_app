import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'done_states.dart';

class DoneCubit extends Cubit<DoneStates> {
  DoneCubit() : super(ResetPassDoneInitialState());

  static DoneCubit get(context) => BlocProvider.of(context);

  Future<void> resetPasswordDone({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPassDoneLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/password-reset-done/"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "new_password": newPassword,
          "confirm_password": confirmPassword,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ResetPassDoneSuccessState(
            message: responseBody["message"] ?? "Password reset successfully"));
      } else {
        emit(FailedToResetPassDoneState(
            error: responseBody["error"] ?? "Unknown error"));
      }
    } catch (e) {
      emit(FailedToResetPassDoneState(error: e.toString()));
    }
  }
}
