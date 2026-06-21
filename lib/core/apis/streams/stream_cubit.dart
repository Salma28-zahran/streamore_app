import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/apis/streams/stream_state.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

import 'stream_model.dart';

class StreamCubit extends Cubit<StreamState> {
  StreamCubit() : super(StreamInitial());

  static StreamCubit get(context) =>
      BlocProvider.of(context);

  Future<StreamModel?> createStream({
    required String name,
    required String description,
    required String layoutType,
  }) async {
    emit(
      CreateStreamLoading(),
    );

    try {
      final token =
      await StorageHelper.getToken();

      print("TOKEN => $token");

      final response =
      await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/streams/',
        ),
        headers: {
          "accept": "application/json",
          "Content-Type":
          "application/json",
          "Authorization":
          "Token $token",
        },
        body: jsonEncode({
          "name": name,
          "description":
          description,
          "layout_type":
          layoutType,
        }),
      );

      final data =
      jsonDecode(
        response.body,
      );

      print(
        "STATUS => ${response.statusCode}",
      );
      print(
        "BODY => ${response.body}",
      );

      if (response.statusCode ==
          200 ||
          response.statusCode ==
              201) {
        final model =
        StreamModel.fromJson(
          data,
        );

        emit(
          CreateStreamSuccess(
            model,
          ),
        );

        return model;
      } else {
        emit(
          CreateStreamError(
            data["error"]
            ?["message"] ??
                "Something went wrong",
          ),
        );

        return null;
      }
    } catch (e) {
      emit(
        CreateStreamError(
          e.toString(),
        ),
      );

      return null;
    }
  }
}