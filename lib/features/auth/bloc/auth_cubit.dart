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
        Uri.parse("https://api.streamore.net/api/users/register/"),
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
  Future<void> autoLogin() async {
    final token = await StorageHelper.getToken();
    if (token != null && token.isNotEmpty) {
      final userId = await StorageHelper.getUserId();
      debugPrint("🔑 Token found → auto login success");
      debugPrint("👤 Logged in User ID: $userId");
      emit(LogInSuccessState());
    } else {
      debugPrint("🚪 No token → go to onboarding/login");
      emit(AuthInitialState());
    }
  }


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
        Uri.parse("https://api.streamore.net/api/users/activate/"),
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

  String? loggedInEmail;
  String? loggedInPassword;

  void login({required String email, required String password}) async {
    emit(LogInLoadingState());

    try {
      final response = await http.post(
        Uri.parse("https://api.streamore.net/api/users/login/"),
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
          final token = data['token'] ?? "";
          final user = data['user'];
          final userId = data['userId'];
          final role = data['role'] ?? "";

          await StorageHelper.saveToken(token);
          await StorageHelper.saveEmail(email);
          await StorageHelper.savePassword(password);

          if (userId != null) {
            await StorageHelper.saveUserId(userId);
            debugPrint("🆔 Saved UserId: $userId");
          } else {
            debugPrint("⚠️ UserId is null → check API response format");
          }

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
    debugPrint("🚪 Trying logout with token: $token");

    try {
      if (token != null && token.isNotEmpty) {
        final response = await http.post(
          Uri.parse("https://api.streamore.net/api/users/logout/"),
          headers: {
            "accept": "*/*",
            "Content-Type": "application/json",
            "Authorization": "Token $token",
          },
        );

        try {
          final responseBody = jsonDecode(response.body);
          debugPrint("📦 Logout Response: $responseBody");

          if (response.statusCode == 200 || response.statusCode == 201) {
            await StorageHelper.clearToken();
            emit(LogOutSuccessState(
                message: responseBody["Message"] ?? "Logged out successfully"));
            return;
          } else {
            debugPrint("⚠️ Logout failed on server: $responseBody");
          }
        } catch (_) {
          debugPrint("⚠️ Logout response is not JSON: ${response.body}");
        }
      }

      await StorageHelper.clearToken();
      emit(LogOutSuccessState(message: "Logged out locally"));
    } catch (e) {
      await StorageHelper.clearToken();
      emit(FailedToLogOutState(error: e.toString()));
    }
  }


  void sendActivate({required String email}) async {
    emit(SendActivateLoadingState());

    try {
      final response = await http.post(
        Uri.parse("https://api.streamore.net/api/users/sendactivate/"),
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
        Uri.parse("https://api.streamore.net/api/users/resetpassword/"),

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

  Future<void> verifyPassCode(
      {required String email, required String code}) async {
    emit(VerifyPassCodeLoadingState());
    try {
      final response = await http.post(
        Uri.parse("https://api.streamore.net/api/users/resetpassword-verify/"),
        body: {
          "email": email,
          "reset_code": code,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(VerifyPassCodeSuccessState(
            message: data["message"] ?? "Code Verified"));
      } else {
        final error =
            json.decode(response.body)["error"] ?? "Failed to verify code";
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
        Uri.parse("https://api.streamore.net/api/users/password-reset-done/"),
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
        Uri.parse("https://api.streamore.net/api/users/change-password/"),
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

