import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart'
as http;
import 'package:streamore_app/core/apis/host_token/host_token_state.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

import 'host_token_model.dart';


class HostTokenCubit
    extends Cubit<HostTokenState> {
  HostTokenCubit()
      : super(
    HostTokenInitial(),
  );

  static HostTokenCubit get(
      context,
      ) =>
      BlocProvider.of(context);

  Future<void> getHostToken({
    required int id,
    required int accountId,
    required String name,
    required String description,
    required String layoutType,
  }) async {
    emit(
      HostTokenLoading(),
    );

    try {
      final token =
      await StorageHelper.getToken();

      final response =
      await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/streams/$id/host-token/',
        ),
        headers: {
          "accept":
          "application/json",
          "Content-Type":
          "application/json",
          "Authorization":
          "Bearer $token",
        },
        body: jsonEncode({
          "account_id":
          accountId,
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

      if (response.statusCode ==
          200 ||
          response.statusCode ==
              201) {
        emit(
          HostTokenSuccess(
            HostTokenModel
                .fromJson(
              data,
            ),
          ),
        );
      } else {
        emit(
          HostTokenError(
            data["error"]
            ?["message"] ??
                "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(
        HostTokenError(
          e.toString(),
        ),
      );
    }
  }
}