import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/features/auth/bloc/auth_states.dart';

class AuthCubit extends Cubit<AuthStates>{
  AuthCubit():super(AuthInitialState());



  void register({required String email,required String password})async{
    emit(RegisterLoadingState());
 Response response=  await http.post(
      Uri.parse("http://138.68.187.187:8000/api/users/register/"),
      headers: {
        'lang': "en"
      },
      body: {
        'email': email,
        'password': password,
      }

    );
 var responseBody=jsonDecode(response.body);
 if (response.statusCode == 200 || response.statusCode == 201){
   print(responseBody);
   emit(RegisterSuccessState());
 }
 else {
   print(responseBody);

   final errorMessage =
       responseBody['message'] ?? responseBody['error'] ?? "Unknown error";

   emit(FailedToRegisterState(message: errorMessage));
 }


  }
  void activateAccount({
    required String email,
    required String activationCode,
  }) async {
    emit(ActivateLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/activate/"),
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json', // مهم عشان الـ backend يعرف إنك بتبعت JSON
        },
        body: jsonEncode({
          "email": email,
          "activation_code": activationCode,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Activation success: $responseBody");
        emit(ActivateSuccessState());
      } else {
        print("Activation failed: $responseBody");
        final errorMessage = responseBody['message'] ??
            responseBody['error'] ??
            "Unknown error";
        emit(FailedToActivateState(message: errorMessage));
      }
    } catch (e) {
      emit(FailedToActivateState(message: e.toString()));
    }
  }

  void login({required String email, required String password}) async {
    emit(LogInLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/login/"),
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

  void logout({required String token}) async {
    emit(LogOutLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/logout/"),
        headers: {
          "Authorization": "Token $token",
        },
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(LogOutSuccessState(
            message: responseBody["Message"] ?? "Logged out successfully"));
      } else {
        emit(FailedToLogOutState(
            error: responseBody["error"] ?? "Failed to logout"));
      }
    } catch (e) {
      emit(FailedToLogOutState(error: e.toString()));
    }
  }





}