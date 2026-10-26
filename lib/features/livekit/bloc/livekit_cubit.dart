import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'livekit_state.dart';

class LiveKitCubit extends Cubit<LiveKitState> {
  LiveKitCubit() : super(LiveKitInitial());

  static const String canvasTrackName = 'broadcast-canvas';
  static const String broadcastAudioTrackName = 'broadcast-audio';

  Room? _room;
  LocalVideoTrack? _canvasTrack;

  final List<String> _previousParticipantIds = [];

  Room? get room => _room;

  // ============================================================
  // INITIALIZE LIVEKIT
  // ============================================================

  Future<void> init({
    required String url,
    required String token,
  }) async {
    emit(LiveKitLoading());

    try {
      print('');
      print('======================================');
      print('🚀 LIVEKIT INIT');
      print('======================================');

      final String finalUrl = url.trim();
      final String finalToken = token.trim();

      if (finalUrl.isEmpty) {
        throw Exception('LiveKit URL is empty');
      }

      if (finalToken.isEmpty) {
        throw Exception('LiveKit token is empty');
      }

      print('🌍 LIVEKIT URL => $finalUrl');
      print(
        '🔑 LIVEKIT TOKEN => '
            '${_hideSensitiveValue(finalToken)}',
      );

      if (_room != null) {
        print('⚠️ OLD ROOM FOUND - DISCONNECTING');
        await _clearRoom();
      }

      final PermissionStatus cameraPermission =
      await Permission.camera.request();

      final PermissionStatus microphonePermission =
      await Permission.microphone.request();

      print(
        '📷 CAMERA PERMISSION => '
            '${cameraPermission.isGranted}',
      );

      print(
        '🎤 MICROPHONE PERMISSION => '
            '${microphonePermission.isGranted}',
      );

      if (!cameraPermission.isGranted) {
        throw Exception('Camera permission denied');
      }

      if (!microphonePermission.isGranted) {
        throw Exception('Microphone permission denied');
      }

      final Room newRoom = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
          dynacast: true,
          defaultAudioPublishOptions: AudioPublishOptions(
            name: broadcastAudioTrackName,
          ),
        ),
      );

      _room = newRoom;

      newRoom.addListener(_onRoomUpdate);

      print('🌍 CONNECTING TO LIVEKIT...');

      await newRoom.connect(
        finalUrl,
        finalToken,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
      );

      print('✅ CONNECTED TO LIVEKIT');
      print('🏠 ROOM NAME => ${newRoom.name}');

      final LocalParticipant? localParticipant =
          newRoom.localParticipant;

      if (localParticipant == null) {
        throw Exception(
          'Connected to LiveKit but local participant is null',
        );
      }

      print(
        '👤 LOCAL PARTICIPANT => '
            '${localParticipant.identity}',
      );

      final bool micEnabled = await _enableMicrophone(
        localParticipant: localParticipant,
        microphonePermission: microphonePermission,
      );

      final bool cameraEnabled = await _enableCamera(
        localParticipant: localParticipant,
        cameraPermission: cameraPermission,
      );

      print('🎤 FINAL MIC STATUS => $micEnabled');
      print('📷 FINAL CAMERA STATUS => $cameraEnabled');

      if (!micEnabled) {
        throw Exception(
          'Microphone could not be published',
        );
      }

      if (!cameraEnabled) {
        throw Exception(
          'Camera could not be published',
        );
      }

      _handleJoinLeft();
      _emitParticipants();

      print('✅ LIVEKIT INIT COMPLETED');
    } catch (error, stackTrace) {
      print('');
      print('======================================');
      print('❌ LIVEKIT ERROR');
      print('======================================');

      print('❌ ERROR => $error');
      print('📚 STACK TRACE => $stackTrace');

      try {
        await _clearRoom();
      } catch (clearError) {
        print(
          '⚠️ LIVEKIT CLEANUP ERROR => '
              '$clearError',
        );
      }

      if (!isClosed) {
        emit(
          LiveKitError(
            error.toString(),
          ),
        );
      }

      rethrow;
    }
  }

  // ============================================================
  // PUBLISH CANVAS TRACK
  // ============================================================

  Future<bool> publishCanvasTrack() async {
    final Room? currentRoom = _room;

    final LocalParticipant? localParticipant =
        currentRoom?.localParticipant;

    if (currentRoom == null || localParticipant == null) {
      print(
        '❌ CANNOT PUBLISH CANVAS: '
            'LIVEKIT ROOM IS NOT READY',
      );

      return false;
    }

    LocalVideoTrack? createdTrack;

    try {
      print('');
      print('======================================');
      print('🖥️ PUBLISHING CANVAS TRACK');
      print('======================================');

      final existingCanvas =
      localParticipant.getTrackPublicationByName(
        canvasTrackName,
      );

      if (existingCanvas != null && !existingCanvas.muted) {
        print('✅ CANVAS TRACK ALREADY PUBLISHED');
        print(
          '🆔 CANVAS SID => '
              '${existingCanvas.sid}',
        );

        _printPublishedTracks(localParticipant);

        return true;
      }

      final oldScreenShare =
      localParticipant.getTrackPublicationBySource(
        TrackSource.screenShareVideo,
      );

      if (oldScreenShare != null) {
        print('⚠️ OLD SCREEN SHARE FOUND');
        print(
          '⚠️ OLD TRACK NAME => '
              '${oldScreenShare.name}',
        );
        print(
          '⚠️ OLD TRACK SID => '
              '${oldScreenShare.sid}',
        );

        await localParticipant.removePublishedTrack(
          oldScreenShare.sid,
        );

        await Future.delayed(
          const Duration(milliseconds: 300),
        );
      }

      if (lkPlatformIs(PlatformType.android)) {
        print(
          '📱 REQUESTING ANDROID '
              'SCREEN CAPTURE PERMISSION...',
        );

        final bool hasCapturePermission =
        await webrtc.Helper.requestCapturePermission();

        print(
          '📱 SCREEN CAPTURE PERMISSION => '
              '$hasCapturePermission',
        );

        if (!hasCapturePermission) {
          throw Exception(
            'Screen capture permission denied',
          );
        }

        await _enableAndroidScreenShareService();
      }

      print(
        '🎥 CREATING SCREEN SHARE VIDEO TRACK...',
      );

      createdTrack =
      await LocalVideoTrack.createScreenShareTrack(
        const ScreenShareCaptureOptions(
          maxFrameRate: 30.0,
        ),
      );

      if (createdTrack.isDisposed) {
        throw Exception(
          'Created canvas track is already disposed',
        );
      }

      print(
        '📡 PUBLISHING VIDEO TRACK WITH NAME => '
            '$canvasTrackName',
      );

      final publication =
      await localParticipant.publishVideoTrack(
        createdTrack,
        publishOptions: const VideoPublishOptions(
          name: canvasTrackName,
          simulcast: false,
        ),
      );

      _canvasTrack = createdTrack;

      print('');
      print('✅ SCREEN TRACK PUBLISHED');
      print(
        '🎬 TRACK NAME => '
            '${publication.name}',
      );
      print(
        '🎬 TRACK SOURCE => '
            '${publication.source}',
      );
      print(
        '🆔 TRACK SID => '
            '${publication.sid}',
      );
      print(
        '🔇 TRACK MUTED => '
            '${publication.muted}',
      );

      for (int attempt = 1; attempt <= 20; attempt++) {
        final registeredCanvas =
        localParticipant.getTrackPublicationByName(
          canvasTrackName,
        );

        if (registeredCanvas != null &&
            !registeredCanvas.muted) {
          print('');
          print('✅ CANVAS TRACK VERIFIED');
          print(
            '🎬 CANVAS NAME => '
                '${registeredCanvas.name}',
          );
          print(
            '🎬 CANVAS SOURCE => '
                '${registeredCanvas.source}',
          );
          print(
            '🆔 CANVAS SID => '
                '${registeredCanvas.sid}',
          );
          print(
            '🔇 CANVAS MUTED => '
                '${registeredCanvas.muted}',
          );

          _printPublishedTracks(localParticipant);
          _emitParticipants();

          return true;
        }

        print(
          '⏳ WAITING FOR CANVAS REGISTRATION '
              '=> $attempt/20',
        );

        await Future.delayed(
          const Duration(milliseconds: 250),
        );
      }

      throw Exception(
        'broadcast-canvas was published '
            'but could not be verified',
      );
    } catch (error, stackTrace) {
      print('');
      print('======================================');
      print('❌ CANVAS TRACK PUBLISH ERROR');
      print('======================================');

      print('❌ ERROR => $error');
      print('📚 STACK TRACE => $stackTrace');

      if (createdTrack != null &&
          _canvasTrack != createdTrack &&
          !createdTrack.isDisposed) {
        try {
          await createdTrack.dispose();
        } catch (_) {}
      }

      return false;
    }
  }

  // ============================================================
  // ANDROID SCREEN SHARE SERVICE
  // ============================================================

  Future<void> _enableAndroidScreenShareService() async {
    const FlutterBackgroundAndroidConfig androidConfig =
    FlutterBackgroundAndroidConfig(
      notificationTitle: 'Screen sharing is active',
      notificationText:
      'Streamore is broadcasting your studio screen.',
      notificationImportance:
      AndroidNotificationImportance.normal,
      notificationIcon: AndroidResource(
        name: 'ic_launcher',
        defType: 'mipmap',
      ),
    );

    print(
      '📱 INITIALIZING ANDROID '
          'FOREGROUND SERVICE...',
    );

    final bool initialized =
    await FlutterBackground.initialize(
      androidConfig: androidConfig,
    );

    print(
      '📱 BACKGROUND SERVICE INITIALIZED => '
          '$initialized',
    );

    if (!initialized) {
      throw Exception(
        'Could not initialize Android '
            'screen-share foreground service',
      );
    }

    if (!FlutterBackground.isBackgroundExecutionEnabled) {
      final bool enabled =
      await FlutterBackground.enableBackgroundExecution();

      print(
        '📱 BACKGROUND EXECUTION ENABLED => '
            '$enabled',
      );

      if (!enabled) {
        throw Exception(
          'Could not start Android '
              'screen-share foreground service',
        );
      }
    }

    print(
      '✅ ANDROID SCREEN SHARE SERVICE ENABLED',
    );
  }

  // ============================================================
  // STOP CANVAS TRACK
  // ============================================================

  Future<void> stopCanvasTrack() async {
    final LocalParticipant? localParticipant =
        _room?.localParticipant;

    try {
      final canvasPublication =
      localParticipant?.getTrackPublicationByName(
        canvasTrackName,
      );

      if (localParticipant != null &&
          canvasPublication != null) {
        print(
          '🛑 UNPUBLISHING CANVAS TRACK...',
        );

        await localParticipant.removePublishedTrack(
          canvasPublication.sid,
        );
      }

      final LocalVideoTrack? currentCanvasTrack =
          _canvasTrack;

      _canvasTrack = null;

      if (currentCanvasTrack != null &&
          !currentCanvasTrack.isDisposed) {
        try {
          await currentCanvasTrack.dispose();
        } catch (_) {}
      }

      if (lkPlatformIs(PlatformType.android) &&
          FlutterBackground.isBackgroundExecutionEnabled) {
        await FlutterBackground.disableBackgroundExecution();
      }

      print('✅ CANVAS TRACK STOPPED');
    } catch (error) {
      print(
        '⚠️ STOP CANVAS TRACK ERROR => '
            '$error',
      );
    }
  }

  // ============================================================
  // PRINT TRACKS
  // ============================================================

  void _printPublishedTracks(
      LocalParticipant localParticipant,
      ) {
    print('');
    print('======================================');
    print('📦 PUBLISHED LOCAL TRACKS');
    print('======================================');

    if (localParticipant.trackPublications.isEmpty) {
      print('⚠️ NO LOCAL TRACKS PUBLISHED');
      return;
    }

    for (final publication
    in localParticipant.trackPublications.values) {
      print(
        '• name=${publication.name} '
            '| source=${publication.source} '
            '| sid=${publication.sid} '
            '| muted=${publication.muted}',
      );
    }
  }

  // ============================================================
  // ENABLE MICROPHONE
  // ============================================================

  Future<bool> _enableMicrophone({
    required LocalParticipant localParticipant,
    required PermissionStatus microphonePermission,
  }) async {
    if (!microphonePermission.isGranted) {
      print(
        '⚠️ MICROPHONE NOT ENABLED: '
            'PERMISSION DENIED',
      );

      return false;
    }

    try {
      print('');
      print('======================================');
      print('🎤 ENABLING BROADCAST AUDIO');
      print('======================================');

      await localParticipant.setMicrophoneEnabled(true);

      for (int attempt = 1; attempt <= 20; attempt++) {
        final bool isMicOn =
        localParticipant.isMicrophoneEnabled();

        final broadcastAudioPublication =
        localParticipant.getTrackPublicationByName(
          broadcastAudioTrackName,
        );

        final bool isBroadcastAudioReady =
            isMicOn &&
                broadcastAudioPublication != null &&
                !broadcastAudioPublication.muted;

        if (isBroadcastAudioReady) {
          print('');
          print('✅ BROADCAST AUDIO VERIFIED');
          print(
            '🎤 NAME => '
                '${broadcastAudioPublication.name}',
          );
          print(
            '🎤 SOURCE => '
                '${broadcastAudioPublication.source}',
          );
          print(
            '🆔 SID => '
                '${broadcastAudioPublication.sid}',
          );
          print(
            '🔇 MUTED => '
                '${broadcastAudioPublication.muted}',
          );

          return true;
        }

        print(
          '⏳ WAITING FOR BROADCAST AUDIO '
              '=> $attempt/20',
        );
        print(
          '🎤 MICROPHONE ENABLED => '
              '$isMicOn',
        );
        print(
          '🎤 AUDIO PUBLICATION => '
              '${broadcastAudioPublication?.name ?? 'NOT FOUND'}',
        );

        await Future.delayed(
          const Duration(milliseconds: 250),
        );
      }

      print(
        '❌ BROADCAST AUDIO TRACK '
            'WAS NOT PUBLISHED CORRECTLY',
      );

      return false;
    } catch (error, stackTrace) {
      print(
        '⚠️ MICROPHONE ENABLE ERROR => '
            '$error',
      );
      print(
        '📚 STACK TRACE => '
            '$stackTrace',
      );

      return false;
    }
  }

  // ============================================================
  // ENABLE CAMERA
  // ============================================================

  Future<bool> _enableCamera({
    required LocalParticipant localParticipant,
    required PermissionStatus cameraPermission,
  }) async {
    if (!cameraPermission.isGranted) {
      print('❌ CAMERA PERMISSION DENIED');
      return false;
    }

    try {
      print('📷 ENABLING CAMERA...');

      await localParticipant.setCameraEnabled(true);

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      final bool isCameraOn =
      localParticipant.isCameraEnabled();

      print(
        '📷 CAMERA STATUS => $isCameraOn',
      );

      return isCameraOn;
    } catch (error, stackTrace) {
      print(
        '❌ CAMERA ENABLE ERROR => $error',
      );
      print(
        '📚 STACK TRACE => $stackTrace',
      );

      return false;
    }
  }

  // ============================================================
  // ROOM LISTENER
  // ============================================================

  void _onRoomUpdate() {
    if (isClosed) {
      return;
    }

    _handleJoinLeft();
    _emitParticipants();
  }

  // ============================================================
  // PARTICIPANTS JOIN / LEAVE
  // ============================================================

  void _handleJoinLeft() {
    final Room? currentRoom = _room;

    if (currentRoom == null) {
      return;
    }

    final List<String> currentParticipantIds = [];

    final LocalParticipant? localParticipant =
        currentRoom.localParticipant;

    if (localParticipant != null) {
      currentParticipantIds.add(
        localParticipant.identity,
      );
    }

    for (final participant
    in currentRoom.remoteParticipants.values) {
      currentParticipantIds.add(
        participant.identity,
      );
    }

    for (final String participantId
    in currentParticipantIds) {
      if (!_previousParticipantIds.contains(
        participantId,
      )) {
        print(
          '👤 JOINED => $participantId',
        );
      }
    }

    for (final String participantId
    in _previousParticipantIds) {
      if (!currentParticipantIds.contains(
        participantId,
      )) {
        print(
          '👤 LEFT => $participantId',
        );
      }
    }

    _previousParticipantIds
      ..clear()
      ..addAll(currentParticipantIds);
  }

  // ============================================================
  // EMIT PARTICIPANTS
  // ============================================================

  void _emitParticipants() {
    if (isClosed) {
      return;
    }

    final Room? currentRoom = _room;

    if (currentRoom == null) {
      return;
    }

    final LocalParticipant? localParticipant =
        currentRoom.localParticipant;

    if (localParticipant == null) {
      return;
    }

    final List<Participant> participants = [
      localParticipant,
      ...currentRoom.remoteParticipants.values,
    ];

    emit(
      LiveKitConnected(
        participants: participants,
        localParticipant: localParticipant,
        isMuted:
        !localParticipant.isMicrophoneEnabled(),
        isCameraOff:
        !localParticipant.isCameraEnabled(),
      ),
    );
  }

  // ============================================================
  // TOGGLE MICROPHONE
  // ============================================================

  Future<void> toggleMic() async {
    final LocalParticipant? localParticipant =
        _room?.localParticipant;

    if (localParticipant == null) {
      print(
        '⚠️ CANNOT TOGGLE MIC: '
            'LOCAL PARTICIPANT IS NULL',
      );
      return;
    }

    try {
      final bool isEnabled =
      localParticipant.isMicrophoneEnabled();

      await localParticipant.setMicrophoneEnabled(
        !isEnabled,
      );

      print(
        '🎤 MICROPHONE ENABLED => '
            '${!isEnabled}',
      );

      _emitParticipants();
    } catch (error) {
      print(
        '❌ TOGGLE MIC ERROR => $error',
      );

      if (!isClosed) {
        emit(
          LiveKitError(
            'Toggle microphone failed: $error',
          ),
        );
      }
    }
  }

  // ============================================================
  // TOGGLE CAMERA
  // ============================================================

  Future<void> toggleCamera() async {
    final LocalParticipant? localParticipant =
        _room?.localParticipant;

    if (localParticipant == null) {
      print(
        '⚠️ CANNOT TOGGLE CAMERA: '
            'LOCAL PARTICIPANT IS NULL',
      );
      return;
    }

    try {
      final bool isEnabled =
      localParticipant.isCameraEnabled();

      if (isEnabled) {
        await localParticipant.setCameraEnabled(false);
      } else {
        await _enableCamera(
          localParticipant: localParticipant,
          cameraPermission:
          await Permission.camera.request(),
        );
      }

      print(
        '📷 CAMERA ENABLED => '
            '${localParticipant.isCameraEnabled()}',
      );

      _emitParticipants();
    } catch (error) {
      print(
        '❌ TOGGLE CAMERA ERROR => $error',
      );

      if (!isClosed) {
        emit(
          LiveKitError(
            'Toggle camera failed: $error',
          ),
        );
      }
    }
  }

  // ============================================================
  // DISCONNECT
  // ============================================================

  Future<void> disconnect() async {
    try {
      print('❌ DISCONNECTING LIVEKIT');

      await _clearRoom();

      if (!isClosed) {
        emit(LiveKitInitial());
      }

      print('✅ LIVEKIT DISCONNECTED');
    } catch (error, stackTrace) {
      print(
        '❌ LIVEKIT DISCONNECT ERROR => '
            '$error',
      );
      print(
        '📚 STACK TRACE => $stackTrace',
      );

      if (!isClosed) {
        emit(
          LiveKitError(
            'Disconnect failed: $error',
          ),
        );
      }
    }
  }

  // ============================================================
  // CLEAR ROOM
  // ============================================================

  Future<void> _clearRoom() async {
    final Room? currentRoom = _room;
    final LocalVideoTrack? currentCanvasTrack =
        _canvasTrack;

    _room = null;
    _canvasTrack = null;
    _previousParticipantIds.clear();

    if (currentRoom != null) {
      currentRoom.removeListener(
        _onRoomUpdate,
      );

      await currentRoom.disconnect();
    }

    if (currentCanvasTrack != null &&
        !currentCanvasTrack.isDisposed) {
      try {
        await currentCanvasTrack.dispose();
      } catch (_) {}
    }

    if (lkPlatformIs(PlatformType.android) &&
        FlutterBackground.isBackgroundExecutionEnabled) {
      try {
        await FlutterBackground.disableBackgroundExecution();
      } catch (error) {
        print(
          '⚠️ BACKGROUND SERVICE STOP ERROR => '
              '$error',
        );
      }
    }
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

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  Future<void> close() async {
    try {
      await _clearRoom();
    } catch (error) {
      print(
        '⚠️ LIVEKIT CLOSE ERROR => $error',
      );
    }

    return super.close();
  }
}