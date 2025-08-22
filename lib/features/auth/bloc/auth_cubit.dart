import 'dart:convert';

import 'package:bloc/bloc.dart';
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

}