import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'delete_account_states.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  Future<void> deleteAccount({
    required String token,
    required String email,
    required String password,
  }) async {
    emit(DeleteAccountLoading());

    final uri = Uri.parse('http://34.39.27.45:8000/api/users/delete-account/');

    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final body = jsonEncode({"email": email, "password": password});

      final response = await http
          .delete(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 204) {
        emit(DeleteAccountSuccess());
        return;
      }

      String message = 'Request failed (${response.statusCode})';
      try {
        final jsonBody = jsonDecode(response.body);
        if (jsonBody is Map) {
          message = jsonBody['detail'] ??
              jsonBody['message'] ??
              jsonBody['error'] ??
              jsonBody.toString();
        } else {
          message = response.body;
        }
      } catch (_) {
        message = response.body.isNotEmpty ? response.body : message;
      }

      emit(DeleteAccountError(message));
    } catch (e) {
      emit(DeleteAccountError(e.toString()));
    }
  }
}
