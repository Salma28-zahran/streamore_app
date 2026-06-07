import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/apis/destination/DestinationModel.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';


part 'destination_state.dart';

class DestinationCubit extends Cubit<DestinationState> {
  DestinationCubit() : super(DestinationInitial());

  static DestinationCubit get(context) =>
      BlocProvider.of(context);

  Future<void> createDestination({
    required String name,
    required String platformType,
    required String rtmpUrl,
    required String rtmpKey,
    required String streamUrl,
  }) async {
    emit(CreateDestinationLoading());

    try {
      final token = await StorageHelper.getToken();

      final response = await http.post(
        Uri.parse(
          'https://apistreamore.genius-ai.net/api/streams/destinations/',
        ),
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",

          /// لو backend عندكم Bearer
          "Authorization": "Token $token",
        },
        body: jsonEncode({
          "name": name,
          "platform_type": platformType,
          "rtmp_url": rtmpUrl,
          "rtmp_key": rtmpKey,
          "stream_url": streamUrl,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        final destination =
        DestinationModel.fromJson(data);

        emit(
          CreateDestinationSuccess(destination),
        );
      } else {
        emit(
          CreateDestinationError(
            data["error"]?["message"] ??
                "Something went wrong",
          ),
        );
      }
    } catch (e) {
      emit(
        CreateDestinationError(e.toString()),
      );
    }
  }
}