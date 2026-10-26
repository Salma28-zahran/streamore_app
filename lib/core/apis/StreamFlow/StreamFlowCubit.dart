import 'package:bloc/bloc.dart';

import 'package:streamore_app/core/apis/StreamFlow/StreamFlowState.dart';
import 'package:streamore_app/core/apis/connect_des/connect_destination_cubit.dart';
import 'package:streamore_app/core/apis/destination/destination_cubit.dart';
import 'package:streamore_app/core/apis/host_token/host_token_cubit.dart';
import 'package:streamore_app/core/apis/host_token/host_token_state.dart';
import 'package:streamore_app/core/apis/start/start_stream_cubit.dart';
import 'package:streamore_app/core/apis/start/start_stream_model.dart';
import 'package:streamore_app/core/apis/stream_des/stream_destinations_cubit.dart';
import 'package:streamore_app/core/apis/streams/stream_cubit.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/features/livekit/bloc/livekit_cubit.dart';

class StreamFlowCubit extends Cubit<StreamFlowState> {
  StreamFlowCubit({
    required this.streamCubit,
    required this.destinationCubit,
    required this.connectCubit,
    required this.attachCubit,
    required this.hostTokenCubit,
    required this.startStreamCubit,
    required this.liveKitCubit,
  }) : super(StreamFlowInitial());

  final StreamCubit streamCubit;
  final DestinationCubit destinationCubit;
  final ConnectDestinationCubit connectCubit;
  final StreamDestinationsCubit attachCubit;
  final HostTokenCubit hostTokenCubit;
  final StartStreamCubit startStreamCubit;
  final LiveKitCubit liveKitCubit;

  // ============================================================
  // START FULL FLOW
  // ============================================================

  Future<void> startFullFlow({
    required int accountId,
    required String name,
    required String description,
    required String layoutType,
    required String csrfToken,
    required String authToken,
    required String facebookRtmpUrl,
    required String facebookRtmpKey,
    String facebookStreamUrl = 'https://www.facebook.com',
  }) async {
    if (state is StreamFlowLoading) {
      print('⚠️ STREAM FLOW ALREADY RUNNING');
      return;
    }

    emit(StreamFlowLoading());

    bool canvasPublished = false;

    try {
      print('');
      print('======================================');
      print('🚀 FACEBOOK STREAM FLOW STARTED');
      print('======================================');

      // ==========================================================
      // VALIDATION
      // ==========================================================

      if (accountId <= 0) {
        emit(
          StreamFlowError(
            'Invalid account ID',
          ),
        );
        return;
      }

      if (name.trim().isEmpty) {
        emit(
          StreamFlowError(
            'Stream name is empty',
          ),
        );
        return;
      }

      if (layoutType.trim().isEmpty) {
        emit(
          StreamFlowError(
            'Layout type is empty',
          ),
        );
        return;
      }

      if (facebookRtmpUrl.trim().isEmpty) {
        emit(
          StreamFlowError(
            'Facebook RTMP URL is empty',
          ),
        );
        return;
      }

      if (facebookRtmpKey.trim().isEmpty) {
        emit(
          StreamFlowError(
            'Facebook Stream Key is empty',
          ),
        );
        return;
      }

      print('✅ BASIC VALIDATION PASSED');

      // ==========================================================
      // AUTH TOKEN
      // ==========================================================

      String finalAuthToken = authToken.trim();

      if (finalAuthToken.isEmpty) {
        finalAuthToken =
            (await StorageHelper.getToken())?.trim() ?? '';
      }

      if (finalAuthToken.isEmpty) {
        emit(
          StreamFlowError(
            'Auth token is empty',
          ),
        );
        return;
      }

      print('✅ AUTH TOKEN FOUND');
      print('👤 REQUESTED ACCOUNT ID => $accountId');

      if (csrfToken.trim().isNotEmpty) {
        print('✅ CSRF TOKEN PROVIDED');
      } else {
        print('ℹ️ CSRF TOKEN NOT PROVIDED');
      }

      // ==========================================================
      // STEP 1: CREATE STREAM
      // ==========================================================

      print('');
      print('======================================');
      print('1️⃣ CREATING STREAM...');
      print('======================================');

      final dynamic stream =
      await streamCubit.createStream(
        name: name.trim(),
        description: description.trim(),
        layoutType: layoutType.trim(),
      );

      if (stream == null) {
        emit(
          StreamFlowError(
            'Stream creation failed',
          ),
        );
        return;
      }

      final int? streamId =
      _extractStreamId(stream);

      if (streamId == null || streamId <= 0) {
        emit(
          StreamFlowError(
            'Stream ID not found in create stream response',
          ),
        );
        return;
      }

      final int? responseAccountId =
      _extractAccountId(stream);

      final int finalAccountId =
          responseAccountId ?? accountId;

      if (finalAccountId <= 0) {
        emit(
          StreamFlowError(
            'Valid stream account ID not found',
          ),
        );
        return;
      }

      print('✅ STREAM CREATED');
      print('🆔 STREAM ID => $streamId');
      print('👤 REQUESTED ACCOUNT ID => $accountId');
      print(
        '👤 STREAM RESPONSE ACCOUNT ID => '
            '${responseAccountId ?? 'NOT FOUND'}',
      );
      print(
        '✅ FINAL ACCOUNT ID => $finalAccountId',
      );

      if (responseAccountId != null &&
          responseAccountId != accountId) {
        print('');
        print(
          '⚠️ REQUESTED ACCOUNT ID DIFFERS '
              'FROM STREAM ACCOUNT ID',
        );
        print(
          '⚠️ REQUESTED ACCOUNT ID => $accountId',
        );
        print(
          '⚠️ STREAM ACCOUNT ID => $responseAccountId',
        );
        print(
          '✅ CONTINUING WITH STREAM ACCOUNT ID '
              '=> $finalAccountId',
        );
      }

      // ==========================================================
      // STEP 2: CREATE FACEBOOK DESTINATION
      // ==========================================================

      print('');
      print('======================================');
      print('2️⃣ CREATING FACEBOOK DESTINATION...');
      print('======================================');

      final destination =
      await destinationCubit.createDestination(
        name: 'Facebook',
        platformType: 'facebook',
        rtmpUrl: facebookRtmpUrl.trim(),
        rtmpKey: facebookRtmpKey.trim(),
        streamUrl: facebookStreamUrl.trim(),
      );

      if (destination == null) {
        emit(
          StreamFlowError(
            'Facebook destination creation failed',
          ),
        );
        return;
      }

      final int? destinationId = destination.id;

      if (destinationId == null ||
          destinationId <= 0) {
        emit(
          StreamFlowError(
            'Invalid Facebook destination ID',
          ),
        );
        return;
      }

      print('✅ FACEBOOK DESTINATION CREATED');
      print('🆔 DESTINATION ID => $destinationId');

      // ==========================================================
      // STEP 3: CONNECT DESTINATION
      // ==========================================================

      print('');
      print('======================================');
      print('3️⃣ CONNECTING FACEBOOK DESTINATION...');
      print('======================================');

      print('🆔 DESTINATION ID => $destinationId');
      print('👤 ACCOUNT ID => $finalAccountId');

      final dynamic connect =
      await connectCubit.connectDestination(
        destinationId: destinationId,
        accountId: finalAccountId,
        name: name.trim(),
        platformType: 'facebook',
        rtmpKey: facebookRtmpKey.trim(),
        streamUrl: facebookStreamUrl.trim(),
      );

      if (connect == null) {
        emit(
          StreamFlowError(
            'Connect Facebook destination failed',
          ),
        );
        return;
      }

      print('✅ FACEBOOK DESTINATION CONNECTED');

      // ==========================================================
      // STEP 4: ATTACH DESTINATION
      // ==========================================================

      print('');
      print('======================================');
      print('4️⃣ ATTACHING FACEBOOK DESTINATION...');
      print('======================================');

      print('📺 STREAM ID => $streamId');
      print('🔗 DESTINATION ID => $destinationId');

      final dynamic attach =
      await attachCubit.attachDestination(
        streamId: streamId,
        destinationId: destinationId,
      );

      if (attach == null) {
        emit(
          StreamFlowError(
            'Attach Facebook destination failed',
          ),
        );
        return;
      }

      print('✅ FACEBOOK DESTINATION ATTACHED');

      // ==========================================================
      // STEP 5: GET HOST TOKEN
      // ==========================================================

      print('');
      print('======================================');
      print('5️⃣ GETTING HOST TOKEN...');
      print('======================================');

      print('📺 STREAM ID => $streamId');
      print('👤 ACCOUNT ID => $finalAccountId');

      await hostTokenCubit.getHostToken(
        id: streamId,
        accountId: finalAccountId,
        name: name.trim(),
        description: description.trim(),
        layoutType: layoutType.trim(),
      );

      final HostTokenState hostState =
          hostTokenCubit.state;

      if (hostState is HostTokenError) {
        emit(
          StreamFlowError(
            hostState.error,
          ),
        );
        return;
      }

      if (hostState is! HostTokenSuccess) {
        emit(
          StreamFlowError(
            'Failed to get host token',
          ),
        );
        return;
      }

      final hostModel = hostState.model;

      final String liveKitToken =
      hostModel.livekitToken.trim();

      final String liveKitUrl =
      hostModel.livekitUrl.trim();

      final String roomName =
      hostModel.roomName.trim();

      if (liveKitToken.isEmpty) {
        emit(
          StreamFlowError(
            'Host LiveKit token is empty',
          ),
        );
        return;
      }

      if (liveKitUrl.isEmpty) {
        emit(
          StreamFlowError(
            'Host LiveKit URL is empty',
          ),
        );
        return;
      }

      if (roomName.isEmpty) {
        emit(
          StreamFlowError(
            'LiveKit room name is empty',
          ),
        );
        return;
      }

      print('✅ HOST TOKEN RECEIVED');
      print('🌍 LIVEKIT URL => $liveKitUrl');
      print('🏠 ROOM NAME => $roomName');
      print(
        '🔑 LIVEKIT TOKEN => '
            '${_hideSensitiveValue(liveKitToken)}',
      );

      // ==========================================================
      // CONNECT TO LIVEKIT
      // ==========================================================

      print('');
      print('======================================');
      print('🎥 CONNECTING TO LIVEKIT AS HOST...');
      print('======================================');

      await liveKitCubit.init(
        url: liveKitUrl,
        token: liveKitToken,
      );

      final participant =
          liveKitCubit.room?.localParticipant;

      if (participant == null) {
        emit(
          StreamFlowError(
            'LiveKit local host participant not found',
          ),
        );
        return;
      }

      final String connectedRoomName =
          liveKitCubit.room?.name?.trim() ?? '';

      print('✅ CONNECTED TO LIVEKIT AS HOST');
      print(
        '👤 HOST PARTICIPANT => '
            '${participant.identity}',
      );
      print(
        '🏠 EXPECTED ROOM => '
            '$roomName',
      );
      print(
        '🏠 CONNECTED ROOM => '
            '$connectedRoomName',
      );

      if (connectedRoomName.isEmpty) {
        emit(
          StreamFlowError(
            'Connected LiveKit room name is empty',
          ),
        );
        return;
      }

      if (connectedRoomName != roomName) {
        emit(
          StreamFlowError(
            'Connected to wrong LiveKit room. '
                'Expected: $roomName, '
                'actual: $connectedRoomName',
          ),
        );
        return;
      }

      // ==========================================================
      // CHECK CAMERA
      // ==========================================================

      final bool isCameraOn;

      try {
        isCameraOn =
            participant.isCameraEnabled();
      } catch (error, stackTrace) {
        print(
          '❌ CAMERA STATUS CHECK FAILED => $error',
        );
        print(
          '📚 STACK TRACE => $stackTrace',
        );

        emit(
          StreamFlowError(
            'Failed to check host camera status',
          ),
        );
        return;
      }

      // ==========================================================
      // CHECK MICROPHONE
      // ==========================================================

      final bool isMicOn;

      try {
        isMicOn =
            participant.isMicrophoneEnabled();
      } catch (error, stackTrace) {
        print(
          '❌ MICROPHONE STATUS CHECK FAILED => $error',
        );
        print(
          '📚 STACK TRACE => $stackTrace',
        );

        emit(
          StreamFlowError(
            'Failed to check host microphone status',
          ),
        );
        return;
      }

      print('');
      print('======================================');
      print('🎥 HOST MEDIA STATUS');
      print('======================================');

      print('📷 HOST CAMERA STATUS => $isCameraOn');
      print('🎤 HOST MICROPHONE STATUS => $isMicOn');

      if (!isCameraOn) {
        emit(
          StreamFlowError(
            'Host camera not published',
          ),
        );
        return;
      }

      if (!isMicOn) {
        emit(
          StreamFlowError(
            'Host microphone not published',
          ),
        );
        return;
      }

      print(
        '✅ HOST CAMERA AND MICROPHONE PUBLISHED',
      );

      // ==========================================================
      // PUBLISH CANVAS BEFORE /START/
      // ==========================================================

      print('');
      print('======================================');
      print('🖥️ PUBLISHING CANVAS TRACK...');
      print('======================================');

      canvasPublished =
      await liveKitCubit.publishCanvasTrack();

      if (!canvasPublished) {
        print('❌ CANVAS TRACK PUBLISH FAILED');

        emit(
          StreamFlowError(
            'Failed to publish broadcast-canvas track',
          ),
        );
        return;
      }

      final canvasPublication =
      participant.getTrackPublicationByName(
        LiveKitCubit.canvasTrackName,
      );

      if (canvasPublication == null) {
        print(
          '❌ broadcast-canvas NOT FOUND '
              'AFTER PUBLISH',
        );

        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'broadcast-canvas track not found '
                'after publishing',
          ),
        );
        return;
      }

      if (canvasPublication.muted) {
        print('❌ broadcast-canvas IS MUTED');

        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'broadcast-canvas track is muted',
          ),
        );
        return;
      }

      if (canvasPublication.name !=
          LiveKitCubit.canvasTrackName) {
        print(
          '❌ WRONG CANVAS NAME => '
              '${canvasPublication.name}',
        );

        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'Wrong canvas track name. '
                'Expected ${LiveKitCubit.canvasTrackName}, '
                'received ${canvasPublication.name}',
          ),
        );
        return;
      }

      print('');
      print('✅ BROADCAST CANVAS TRACK READY');
      print(
        '🎬 CANVAS NAME => '
            '${canvasPublication.name}',
      );
      print(
        '🎬 CANVAS SOURCE => '
            '${canvasPublication.source}',
      );
      print(
        '🆔 CANVAS SID => '
            '${canvasPublication.sid}',
      );
      print(
        '🔇 CANVAS MUTED => '
            '${canvasPublication.muted}',
      );

      final broadcastAudioPublication =
      participant.getTrackPublicationByName(
        LiveKitCubit.broadcastAudioTrackName,
      );

      if (broadcastAudioPublication == null) {
        print(
          '❌ broadcast-audio TRACK NOT FOUND',
        );

        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'broadcast-audio track not found '
                'after publishing',
          ),
        );
        return;
      }

      if (broadcastAudioPublication.muted) {
        print(
          '❌ broadcast-audio TRACK IS MUTED',
        );

        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'broadcast-audio track is muted',
          ),
        );
        return;
      }

      if (broadcastAudioPublication.name !=
          LiveKitCubit.broadcastAudioTrackName) {
        print(
          '❌ WRONG AUDIO NAME => '
              '${broadcastAudioPublication.name}',
        );

        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'Wrong audio track name. '
                'Expected '
                '${LiveKitCubit.broadcastAudioTrackName}, '
                'received '
                '${broadcastAudioPublication.name}',
          ),
        );
        return;
      }

      print('');
      print('✅ BROADCAST AUDIO TRACK READY');
      print(
        '🎤 AUDIO NAME => '
            '${broadcastAudioPublication.name}',
      );
      print(
        '🎤 AUDIO SOURCE => '
            '${broadcastAudioPublication.source}',
      );
      print(
        '🆔 AUDIO SID => '
            '${broadcastAudioPublication.sid}',
      );
      print(
        '🔇 AUDIO MUTED => '
            '${broadcastAudioPublication.muted}',
      );

      print('');
      print('======================================');
      print('📦 FINAL TRACKS BEFORE START REQUEST');
      print('======================================');

      for (final publication
      in participant.trackPublications.values) {
        print(
          '• name=${publication.name} '
              '| source=${publication.source} '
              '| sid=${publication.sid} '
              '| muted=${publication.muted}',
        );
      }

      print('');
      print(
        '⏳ WAITING FOR LIVEKIT SERVER '
            'PROPAGATION...',
      );

      await Future.delayed(
        const Duration(seconds: 3),
      );

      final finalCanvasCheck =
      participant.getTrackPublicationByName(
        LiveKitCubit.canvasTrackName,
      );

      final finalAudioCheck =
      participant.getTrackPublicationByName(
        LiveKitCubit.broadcastAudioTrackName,
      );

      if (finalCanvasCheck == null ||
          finalCanvasCheck.muted) {
        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'broadcast-canvas disappeared '
                'before start request',
          ),
        );
        return;
      }

      if (finalAudioCheck == null ||
          finalAudioCheck.muted) {
        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'broadcast-audio disappeared '
                'before start request',
          ),
        );
        return;
      }

      print('✅ LIVEKIT TRACKS STILL AVAILABLE');
      print(
        '🎬 FINAL CANVAS => '
            '${finalCanvasCheck.name}',
      );
      print(
        '🎤 FINAL AUDIO => '
            '${finalAudioCheck.name}',
      );

      // ==========================================================
      // STEP 6: START FACEBOOK STREAM
      // ==========================================================

      print('');
      print('======================================');
      print('6️⃣ STARTING FACEBOOK STREAM...');
      print('======================================');

      print('📺 STREAM ID => $streamId');
      print('👤 ACCOUNT ID => $finalAccountId');
      print('🔗 DESTINATION ID => $destinationId');
      print('🏠 ROOM NAME => $roomName');
      print(
        '👤 HOST PARTICIPANT => '
            '${participant.identity}',
      );
      print(
        '🎬 CANVAS TRACK => '
            '${finalCanvasCheck.name}',
      );
      print(
        '🎤 AUDIO TRACK => '
            '${finalAudioCheck.name}',
      );

      final StartStreamModel startModel =
      StartStreamModel(
        accountId: finalAccountId,
        name: name.trim(),
        description: description.trim(),
        layoutType: layoutType.trim(),
      );

      final dynamic started =
      await startStreamCubit.startStream(
        streamId: streamId,
        model: startModel,
      );

      if (started == null) {
        print('❌ START FACEBOOK STREAM FAILED');

        await liveKitCubit.stopCanvasTrack();
        canvasPublished = false;

        emit(
          StreamFlowError(
            'Start Facebook stream failed',
          ),
        );
        return;
      }

      // ==========================================================
      // SUCCESS
      // ==========================================================

      print('');
      print('======================================');
      print('🎬 FACEBOOK STREAM STARTED SUCCESSFULLY');
      print('======================================');

      print('📺 STREAM ID => $streamId');
      print('👤 ACCOUNT ID => $finalAccountId');
      print('🔗 DESTINATION ID => $destinationId');
      print('🏠 ROOM NAME => $roomName');
      print(
        '👤 HOST PARTICIPANT => '
            '${participant.identity}',
      );
      print(
        '🎬 CANVAS TRACK => '
            '${finalCanvasCheck.name}',
      );
      print(
        '🎤 AUDIO TRACK => '
            '${finalAudioCheck.name}',
      );

      emit(
        StreamFlowSuccess(
          'Facebook stream started successfully 🚀',
        ),
      );
    } catch (error, stackTrace) {
      print('');
      print('======================================');
      print('❌ FACEBOOK FLOW ERROR');
      print('======================================');

      print('❌ ERROR => $error');
      print('📚 STACK TRACE => $stackTrace');

      if (canvasPublished) {
        try {
          await liveKitCubit.stopCanvasTrack();
        } catch (_) {}
      }

      if (!isClosed) {
        emit(
          StreamFlowError(
            error.toString(),
          ),
        );
      }
    }
  }

  // ============================================================
  // EXTRACT STREAM ID
  // ============================================================

  int? _extractStreamId(
      dynamic stream,
      ) {
    if (stream == null) {
      return null;
    }

    if (stream is Map) {
      final int? id =
      _parsePositiveInt(
        stream['id'],
      );

      if (id != null) {
        return id;
      }

      final dynamic data =
      stream['data'];

      if (data != null && data != stream) {
        return _extractStreamId(
          data,
        );
      }
    }

    try {
      final dynamic object = stream;

      final int? id =
      _parsePositiveInt(
        object.id,
      );

      if (id != null) {
        return id;
      }
    } catch (_) {}

    try {
      final dynamic object = stream;
      final dynamic json = object.toJson();

      if (json != null && json != stream) {
        return _extractStreamId(
          json,
        );
      }
    } catch (_) {}

    return null;
  }

  // ============================================================
  // EXTRACT ACCOUNT ID
  // ============================================================

  int? _extractAccountId(
      dynamic stream,
      ) {
    if (stream == null) {
      return null;
    }

    if (stream is Map) {
      final int? snakeCase =
      _parsePositiveInt(
        stream['account_id'],
      );

      if (snakeCase != null) {
        return snakeCase;
      }

      final int? camelCase =
      _parsePositiveInt(
        stream['accountId'],
      );

      if (camelCase != null) {
        return camelCase;
      }

      final dynamic data =
      stream['data'];

      if (data != null && data != stream) {
        return _extractAccountId(
          data,
        );
      }
    }

    try {
      final dynamic object = stream;

      final int? value =
      _parsePositiveInt(
        object.accountId,
      );

      if (value != null) {
        return value;
      }
    } catch (_) {}

    try {
      final dynamic object = stream;
      final dynamic json = object.toJson();

      if (json != null && json != stream) {
        return _extractAccountId(
          json,
        );
      }
    } catch (_) {}

    return null;
  }

  // ============================================================
  // PARSE POSITIVE INTEGER
  // ============================================================

  int? _parsePositiveInt(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value > 0 ? value : null;
    }

    final int? parsed =
    int.tryParse(
      value.toString().trim(),
    );

    if (parsed == null || parsed <= 0) {
      return null;
    }

    return parsed;
  }

  // ============================================================
  // HIDE TOKEN
  // ============================================================

  String _hideSensitiveValue(
      String value,
      ) {
    final String trimmed = value.trim();

    if (trimmed.isEmpty) {
      return 'EMPTY';
    }

    if (trimmed.length <= 20) {
      return '***';
    }

    return '${trimmed.substring(0, 20)}...';
  }
}