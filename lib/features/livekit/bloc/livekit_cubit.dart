import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'livekit_state.dart';

class LiveKitCubit extends Cubit<LiveKitState> {
  LiveKitCubit() : super(LiveKitInitial());

  Room? _room;

  final List<String> _previousParticipantIds = [];

  /// INIT & CONNECT
  Future<void> init({
    required String url,
    required String token,
  }) async {
    emit(LiveKitLoading());

    try {
      /// ---------------- PERMISSIONS ----------------
      final cam = await Permission.camera.request();
      final mic = await Permission.microphone.request();

      if (!cam.isGranted || !mic.isGranted) {
        emit(LiveKitError("Camera or Microphone permission denied"));
        return;
      }

      /// ---------------- VALIDATE ----------------
      if (url.isEmpty || token.isEmpty) {
        emit(LiveKitError("Empty LiveKit url or token"));
        return;
      }

      /// ---------------- ROOM INIT ----------------
      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
        ),
      );

      _room!.addListener(_onRoomUpdate);

      print("🌍 CONNECTING TO LIVEKIT...");
      print("URL => $url");

      if (token.length > 25) {
        print("TOKEN => ${token.substring(0, 25)}...");
      } else {
        print("TOKEN => $token");
      }

      /// ---------------- CONNECT ----------------
      await _room!.connect(
        url,
        token,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
      );

      print("✅ CONNECTED TO LIVEKIT");

      /// ---------------- ENABLE DEVICES ----------------
      final local = _room!.localParticipant;

      if (local != null) {
        await local.setCameraEnabled(true);
        await local.setMicrophoneEnabled(true);
      }

      _emitParticipants();
    } catch (e) {
      print("❌ LIVEKIT ERROR => $e");
      emit(LiveKitError(e.toString()));
    }
  }

  /// ROOM UPDATE
  void _onRoomUpdate() {
    _handleJoinLeft();
    _emitParticipants();
  }

  /// JOIN / LEFT TRACKING
  void _handleJoinLeft() {
    final room = _room;
    if (room == null) return;

    final currentIds = <String>[];

    final local = room.localParticipant;
    if (local != null) {
      currentIds.add(local.identity);
    }

    for (final p in room.remoteParticipants.values) {
      currentIds.add(p.identity);
    }

    for (final id in currentIds) {
      if (!_previousParticipantIds.contains(id)) {
        print("👤 JOINED => $id");
      }
    }

    for (final id in _previousParticipantIds) {
      if (!currentIds.contains(id)) {
        print("👤 LEFT => $id");
      }
    }

    _previousParticipantIds
      ..clear()
      ..addAll(currentIds);
  }

  /// EMIT PARTICIPANTS
  void _emitParticipants() {
    final room = _room;
    if (room == null) return;

    final local = room.localParticipant;

    final participants = <Participant>[
      if (local != null) local,
      ...room.remoteParticipants.values,
    ];

    emit(
      LiveKitConnected(
        participants: participants,
        localParticipant: local,
        isMuted: !(local?.isMicrophoneEnabled() ?? false),
        isCameraOff: !(local?.isCameraEnabled() ?? false),
      ),
    );
  }

  /// TOGGLE MIC
  Future<void> toggleMic() async {
    final local = _room?.localParticipant;
    if (local == null) return;

    final enabled = local.isMicrophoneEnabled();
    await local.setMicrophoneEnabled(!enabled);

    _emitParticipants();
  }

  /// TOGGLE CAMERA
  Future<void> toggleCamera() async {
    final local = _room?.localParticipant;
    if (local == null) return;

    final enabled = local.isCameraEnabled();
    await local.setCameraEnabled(!enabled);

    _emitParticipants();
  }

  /// DISCONNECT
  Future<void> disconnect() async {
    try {
      await _room?.disconnect();
      _room?.removeListener(_onRoomUpdate);

      _room = null;
      _previousParticipantIds.clear();

      emit(LiveKitInitial());

      print("❌ DISCONNECTED FROM LIVEKIT");
    } catch (e) {
      emit(LiveKitError("Disconnect failed: $e"));
    }
  }

  @override
  Future<void> close() {
    disconnect();
    return super.close();
  }
}