import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:streamore_app/core/apis/host_token/host_token_model.dart';
import 'package:streamore_app/core/apis/host_token/host_token_state.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';

class HostTokenCubit extends Cubit<HostTokenState> {
  HostTokenCubit() : super(
    HostTokenInitial(),
  );

  static HostTokenCubit get(
      context,
      ) {
    return BlocProvider.of<HostTokenCubit>(
      context,
    );
  }

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
      // ============================================================
      // AUTH TOKEN
      // ============================================================

      final token = await StorageHelper.getToken();

      if (token == null ||
          token.trim().isEmpty) {
        debugPrint(
          "❌ HOST TOKEN ERROR => AUTH TOKEN IS EMPTY",
        );

        emit(
          HostTokenError(
            "Authentication token is empty",
          ),
        );

        return;
      }

      // ============================================================
      // URL
      // ============================================================

      final url = Uri.parse(
        'https://apistreamore.genius-ai.net'
            '/api/streams/streams/$id/host-token/',
      );

      // ============================================================
      // REQUEST BODY
      // ============================================================

      final requestBody = {
        "account_id": accountId,
        "name": name,
        "description": description,
        "layout_type": layoutType,
      };

      debugPrint("");
      debugPrint(
        "======================================",
      );
      debugPrint(
        "🎙️ GETTING HOST TOKEN...",
      );
      debugPrint(
        "======================================",
      );

      debugPrint(
        "🌍 HOST TOKEN URL => $url",
      );

      debugPrint(
        "📺 STREAM ID => $id",
      );

      debugPrint(
        "👤 ACCOUNT ID => $accountId",
      );

      debugPrint(
        "📦 HOST TOKEN REQUEST BODY => "
            "$requestBody",
      );

      // ============================================================
      // REQUEST
      // ============================================================

      final response = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
          "Authorization":
          "Token ${token.trim()}",
        },
        body: jsonEncode(
          requestBody,
        ),
      );

      debugPrint(
        "📡 HOST TOKEN STATUS => "
            "${response.statusCode}",
      );

      debugPrint(
        "📡 HOST TOKEN BODY => "
            "${response.body}",
      );

      // ============================================================
      // DECODE JSON
      // ============================================================

      dynamic decodedData;

      try {
        decodedData = jsonDecode(
          response.body,
        );
      } catch (e) {
        debugPrint(
          "❌ INVALID HOST TOKEN JSON => $e",
        );

        emit(
          HostTokenError(
            "Invalid host token response",
          ),
        );

        return;
      }

      // ============================================================
      // SUCCESS
      // ============================================================

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        if (decodedData
        is! Map<String, dynamic>) {
          emit(
            HostTokenError(
              "Unexpected host token response format",
            ),
          );

          return;
        }

        final model =
        HostTokenModel.fromJson(
          decodedData,
        );

        debugPrint(
          "✅ HOST TOKEN MODEL PARSED",
        );

        debugPrint(
          "🌍 LIVEKIT URL => "
              "${model.livekitUrl}",
        );

        debugPrint(
          "🏠 ROOM NAME => "
              "${model.roomName}",
        );

        // ما نطبعش الـ token كامل
        if (model.livekitToken.length > 20) {
          debugPrint(
            "🔑 LIVEKIT HOST TOKEN => "
                "${model.livekitToken.substring(0, 20)}...",
          );
        } else if (model.livekitToken.isNotEmpty) {
          debugPrint(
            "🔑 LIVEKIT HOST TOKEN RECEIVED",
          );
        } else {
          debugPrint(
            "❌ LIVEKIT HOST TOKEN EMPTY",
          );
        }

        // ==========================================================
        // VALIDATE LIVEKIT DATA
        // ==========================================================

        if (model.livekitToken.trim().isEmpty) {
          emit(
            HostTokenError(
              "Host LiveKit token is missing from API response",
            ),
          );

          return;
        }

        if (model.livekitUrl.trim().isEmpty) {
          emit(
            HostTokenError(
              "Host LiveKit URL is missing from API response",
            ),
          );

          return;
        }

        emit(
          HostTokenSuccess(
            model,
          ),
        );

        return;
      }

      // ============================================================
      // API ERROR
      // ============================================================

      String errorMessage =
          "Something went wrong";

      if (decodedData is Map<String, dynamic>) {
        final error =
        decodedData["error"];

        if (error is Map<String, dynamic>) {
          errorMessage =
              error["message"]?.toString() ??
                  errorMessage;
        } else if (error != null) {
          errorMessage =
              error.toString();
        } else if (
        decodedData["message"] != null) {
          errorMessage =
              decodedData["message"].toString();
        }
      }

      debugPrint(
        "❌ HOST TOKEN API ERROR => "
            "$errorMessage",
      );

      emit(
        HostTokenError(
          errorMessage,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint("");
      debugPrint(
        "======================================",
      );
      debugPrint(
        "❌ HOST TOKEN EXCEPTION",
      );
      debugPrint(
        "======================================",
      );

      debugPrint(
        "ERROR => $e",
      );

      debugPrint(
        "STACK TRACE => $stackTrace",
      );

      emit(
        HostTokenError(
          e.toString(),
        ),
      );
    }
  }
}