import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  void register({required String email, required String password}) async {
    emit(RegisterLoadingState());
    Response response = await http.post(
        Uri.parse("http://34.39.27.45:8000/api/users/register/"),
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
}