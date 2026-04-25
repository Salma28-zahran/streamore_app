import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/features/invite/bloc/invite_state.dart';

class InviteCubit extends Cubit<InviteState> {
  InviteCubit() : super(InviteInitial());

  Future<void> loadInvite() async {
    try {
      emit(InviteLoading());

      final token = await StorageHelper.getInviteToken();

      if (token == null) {
        emit(InviteError("No invite token found"));
        return;
      }

      final url = Uri.parse('https://your-api.com/invite/$token');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        emit(
          InviteLoaded(
            streamName: data['name'],
            participants: data['participants'],
          ),
        );
      } else {
        emit(InviteError("Failed to load invite"));
      }
    } catch (e) {
      emit(InviteError(e.toString()));
    }
  }
  Future<void> joinStream(String name) async {
    try {
      emit(InviteLoading());

      final token = await StorageHelper.getInviteToken();

      final url = Uri.parse('https://your-api.com/invite/$token/join');

      final response = await http.post(
        url,
        body: {
          "name": name,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final liveKitToken = data['livekit_token'];

        /// هنستخدمه في الخطوة اللي بعدها
        emit(InviteJoinSuccess(liveKitToken));
      } else {
        emit(InviteError("Join failed"));
      }
    } catch (e) {
      emit(InviteError(e.toString()));
    }
  }
}