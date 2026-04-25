import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

import 'livekit_state.dart';

class LiveKitCubit extends Cubit<LiveKitState> {
  LiveKitCubit() : super(LiveKitInitial());

  Room? _room;

  String? _url;
  String? _token;

  List<String> _previousParticipantIds = [];

  ///  init & connect
  Future<void> init({
    required String url,
    required String token,
  }) async {
    emit(LiveKitLoading());

    _url = url;
    _token = token;

    try {
      /// 1. Permissions
      final cam = await Permission.camera.request();
      final mic = await Permission.microphone.request();

      if (!cam.isGranted || !mic.isGranted) {
        emit(LiveKitError("Permissions denied"));
        return;
      }

      /// 2. Create room
      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
        ),
      );

      /// 3. Listen for updates
      _room!.addListener(_onRoomUpdate);

      /// 4. Connect
      await _room!.connect(
        url,
        token,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
      );

      /// 5. Enable camera + mic
      await _room!.localParticipant?.setCameraEnabled(true);
      await _room!.localParticipant?.setMicrophoneEnabled(true);

      /// 6. Emit participants
      _emitParticipants();
    } catch (e) {
      emit(LiveKitError(e.toString()));
    }
  }

  /// 🔥 RECONNECT (Network switch handling)
  Future<void> reconnect() async {
    try {
      if (_url == null || _token == null) return;

      print("🔄 Reconnecting to LiveKit...");

      await _room?.disconnect();
      _room?.removeListener(_onRoomUpdate);

      _room = Room(
        roomOptions: const RoomOptions(
          adaptiveStream: true,
        ),
      );

      _room!.addListener(_onRoomUpdate);

      await _room!.connect(
        _url!,
        _token!,
        connectOptions: const ConnectOptions(
          autoSubscribe: true,
        ),
      );

      print("✅ Reconnected successfully");

      _emitParticipants();
    } catch (e) {
      emit(LiveKitError("Reconnect failed: $e"));
    }
  }

  ///  ROOM UPDATE
  void _onRoomUpdate() {
    _handleJoinLeft();
    _emitParticipants();
  }

  ///  JOIN / LEFT logic
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
        print("👤 Participant JOINED: $id");
      }
    }

    for (final id in _previousParticipantIds) {
      if (!currentIds.contains(id)) {
        print("👤 Participant LEFT: $id");
      }
    }

    _previousParticipantIds = currentIds;
  }

  ///  emit participants
  void _emitParticipants() {
    final room = _room;
    if (room == null) return;

    final List<Participant> participants = [];

    final local = room.localParticipant;
    if (local != null) {
      participants.add(local);
    }

    participants.addAll(room.remoteParticipants.values);

    emit(LiveKitConnected(
      participants: participants,
      localParticipant: local,
      isMuted: !(local?.isMicrophoneEnabled() ?? true),
      isCameraOff: !(local?.isCameraEnabled() ?? true),
    ));
  }

  ///  toggle mic
  Future<void> toggleMic() async {
    final participant = _room?.localParticipant;
    if (participant == null) return;

    final enabled = participant.isMicrophoneEnabled();
    await participant.setMicrophoneEnabled(!enabled);

    _emitParticipants();
  }

  ///  toggle camera
  Future<void> toggleCamera() async {
    final participant = _room?.localParticipant;
    if (participant == null) return;

    final enabled = participant.isCameraEnabled();
    await participant.setCameraEnabled(!enabled);

    _emitParticipants();
  }

  ///  disconnect
  Future<void> disconnect() async {
    await _room?.disconnect();
    _room?.removeListener(_onRoomUpdate);
    _room = null;
    _previousParticipantIds = [];

    emit(LiveKitInitial());
  }

  @override
  Future<void> close() async {
    await disconnect();
    return super.close();
  }
}