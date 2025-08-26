import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/features/auth/bloc/auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitialState());

  void register({required String email, required String password}) async {
    emit(RegisterLoadingState());
    Response response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/register/"),
        headers: {
          'lang': "en"
        },
        body: {
          'email': email,
          'password': password,
        });

    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(responseBody);
      emit(RegisterSuccessState());
    } else {
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
          'Content-Type':
          'application/json', // مهم عشان الـ backend يعرف إنك بتبعت JSON
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
        final errorMessage =
            responseBody['message'] ?? responseBody['error'] ?? "Unknown error";
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

  void logout() async {
    emit(LogOutLoadingState());
    final token = await StorageHelper.getToken();
    debugPrint("🚪 Trying logout with token: $token"); // ✅ نطبع التوكن اللي هنستخدمه


    try {
      final token = await StorageHelper.getToken();

      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/logout/"),
        headers: {
          "accept": "*/*",
          "Content-Type": "application/json",
          "Authorization": "Token $token", // أو Bearer على حسب السيرفر
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

  void sendActivate({required String email}) async {
    emit(SendActivateLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/sendactivate/"),
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


  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoadingState());
    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/resetpassword/"),
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





  Future<void> verifyPassCode({required String email, required String code}) async {
    emit(VerifyPassCodeLoadingState());
    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/resetpassword-verify/"),
        body: {
          "email": email,
          "reset_code": code,   // هنا بردو reset_code
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(VerifyPassCodeSuccessState(message: data["message"] ?? "Code Verified"));
      } else {
        final error = json.decode(response.body)["error"] ?? "Failed to verify code";
        emit(FailedToVerifyPassCodeState(error: error));
      }
    } catch (e) {
      emit(FailedToVerifyPassCodeState(error: e.toString()));
    }
  }






  Future<void> resetPasswordDone({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(ResetPassDoneLoadingState());

    try {
      final response = await http.post(
        Uri.parse("http://138.68.187.187:8000/api/users/password-reset-done/"),
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



  Future<void> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoadingState());
    try {
      final response = await http.put(
        Uri.parse("http://138.68.187.187:8000/api/users/change-password/"),
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
          message: responseBody["message"] ?? responseBody["detail"] ?? "Password changed successfully",
        ));
      } else {
        emit(FailedToChangePasswordState(
          error: responseBody["error"] ?? responseBody["detail"] ?? "Failed to change password",
        ));
      }

    } catch (e) {
      emit(FailedToChangePasswordState(error: e.toString()));
    }
  }






}
