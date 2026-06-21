import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'livekit_state.dart';

class LiveKitCubit extends Cubit<LiveKitState> {
  LiveKitCubit() : super(LiveKitInitial());

  Room? _room;

  final List<String> _previousParticipantIds = [];

  Room? get room => _room;

  Future<void> init({
    required String url,
    required String token,
  }) async {
    emit(LiveKitLoading());

    try {
      print("\n====================");
      print("🚀 LIVEKIT INIT");
      print("====================");

      /// PERMISSIONS
      final cam = await Permission.camera.request();
      final mic = await Permission.microphone.request();

      print("📷 CAMERA => ${cam.isGranted}");
      print("🎤 MIC => ${mic.isGranted}");

      if (!cam.isGranted || !mic.isGranted) {
        emit(
          LiveKitError(
            "Camera or Microphone permission denied",
          ),
        );
        return;
      }

      /// VALIDATE
      if (url.isEmpty || token.isEmpty) {
        emit(
          LiveKitError(
            "Empty LiveKit url or token",
          ),
        );
        return;
      }

      print("🌍 URL => $url");

      if (token.length > 30) {
        print("🔑 TOKEN => ${token.substring(0, 30)}...");
      } else {
        print("🔑 TOKEN => $token");
      }

      /// ROOM
      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
        ),
      );

      _room!.addListener(_onRoomUpdate);

      print("🌍 CONNECTING TO LIVEKIT...");

      await _room!.connect(
        url,
        token,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
      );

      print("✅ CONNECTED TO LIVEKIT");

      try {
        print("🏠 ROOM NAME => ${_room?.name}");
      } catch (_) {}

      final local = _room!.localParticipant;

      print(
        "👤 LOCAL PARTICIPANT => ${local?.identity}",
      );

      if (local != null) {
        await local.setCameraEnabled(true);
        await local.setMicrophoneEnabled(true);

        print("📷 CAMERA ENABLED");
        print("🎤 MIC ENABLED");
      }

      _emitParticipants();
    } catch (e, s) {
      print("❌ LIVEKIT ERROR => $e");
      print(s);

      emit(
        LiveKitError(
          e.toString(),
        ),
      );
    }
  }

  void _onRoomUpdate() {
    _handleJoinLeft();
    _emitParticipants();
  }

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

  Future<void> toggleMic() async {
    final local = _room?.localParticipant;

    if (local == null) return;

    final enabled = local.isMicrophoneEnabled();

    await local.setMicrophoneEnabled(!enabled);

    print("🎤 MIC => ${!enabled}");

    _emitParticipants();
  }

  Future<void> toggleCamera() async {
    final local = _room?.localParticipant;

    if (local == null) return;

    final enabled = local.isCameraEnabled();

    await local.setCameraEnabled(!enabled);

    print("📷 CAMERA => ${!enabled}");

    _emitParticipants();
  }

  Future<void> disconnect() async {
    try {
      print("❌ DISCONNECTING LIVEKIT");

      await _room?.disconnect();

      _room?.removeListener(_onRoomUpdate);

      _room = null;

      _previousParticipantIds.clear();

      emit(LiveKitInitial());

      print("✅ LIVEKIT DISCONNECTED");
    } catch (e) {
      emit(
        LiveKitError(
          "Disconnect failed: $e",
        ),
      );
    }
  }

  @override
  Future<void> close() async {
    await disconnect();
    return super.close();
  }
}