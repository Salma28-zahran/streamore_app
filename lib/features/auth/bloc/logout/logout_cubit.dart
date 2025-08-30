import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'logout_states.dart';

class LogoutCubit extends Cubit<LogoutStates> {
  LogoutCubit() : super(LogOutInitialState());

  void logout() async {
    emit(LogOutLoadingState());
    final token = await StorageHelper.getToken();
    debugPrint("🚪 Trying logout with token: $token");

    try {
      final token = await StorageHelper.getToken();

      final response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/logout/"),
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
          "Authorization": "Token $token",
        },
      );

      final responseBody = jsonDecode(response.body);
      debugPrint("📦 Logout Response: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(LogOutSuccessState(
            message: responseBody["Message"] ?? "Logged out successfully"));
      } else {
        emit(FailedToLogOutState(
            error: responseBody["error"] ??
                responseBody["detail"] ??
                "Failed to logout"));
      }
    } catch (e) {
      emit(FailedToLogOutState(error: e.toString()));
    }
  }
}