import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LogInInitialState());

  void login({required String email, required String password}) async {
    emit(LogInLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/login/"),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      debugPrint("📡 Status Code: ${response.statusCode}");
      debugPrint("📦 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['Message'] == "Login Success") {
          var token = data['token'] ?? "";
          await StorageHelper.saveToken(token);

          var role = data['role'] ?? "";

          debugPrint("✅ Login success. Token: $token, Role: $role");

          emit(LogInSuccessState());
        } else {
          debugPrint("❌ Login failed: ${data['Message']}");
          emit(FailedToLogInState());
        }
      } else {
        debugPrint("❌ Server Error: $data");
        emit(FailedToLogInState());
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      emit(FailedToLogInState());
    }
  }
}