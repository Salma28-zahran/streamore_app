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
print('\n====================');
print('🚀 LIVEKIT INIT');
print('====================');

// =========================================
// VALIDATE URL AND TOKEN
// =========================================
if (url.trim().isEmpty) {
throw Exception('LiveKit URL is empty');
}

if (token.trim().isEmpty) {
throw Exception('LiveKit token is empty');
}

print('🌍 LIVEKIT URL => $url');

if (token.length > 30) {
print(
'🔑 LIVEKIT TOKEN => '
'${token.substring(0, 30)}...',
);
} else {
print('🔑 LIVEKIT TOKEN RECEIVED');
}

// =========================================
// REMOVE OLD ROOM IF INIT CALLED AGAIN
// =========================================
if (_room != null) {
print('⚠️ OLD ROOM FOUND - DISCONNECTING');

try {
await _clearRoom();
} catch (e) {
print('⚠️ OLD ROOM DISCONNECT ERROR => $e');
}
}

// =========================================
// REQUEST CAMERA AND MICROPHONE PERMISSIONS
// =========================================
final cameraPermission =
await Permission.camera.request();

final microphonePermission =
await Permission.microphone.request();

print(
'📷 CAMERA PERMISSION => '
'${cameraPermission.isGranted}',
);

print(
'🎤 MICROPHONE PERMISSION => '
'${microphonePermission.isGranted}',
);

/*
       * مهم:
       * عدم وجود صلاحية الكاميرا أو الميكروفون
       * لا يمنع دخول غرفة LiveKit.
       *
       * التطبيق سيدخل الغرفة أولًا، ثم يشغل
       * الكاميرا أو الميكروفون حسب الصلاحيات.
       */

// =========================================
// CREATE LIVEKIT ROOM OBJECT
// =========================================
final newRoom = Room(
roomOptions: const RoomOptions(
adaptiveStream: true,
),
);

_room = newRoom;

newRoom.addListener(_onRoomUpdate);

print('🌍 CONNECTING TO LIVEKIT...');

// =========================================
// CONNECT TO LIVEKIT ROOM
//
// LiveKit creates the room automatically
// when the first participant joins.
// =========================================
await newRoom.connect(
url,
token,
connectOptions: const ConnectOptions(
autoSubscribe: true,
),
);

print('✅ CONNECTED TO LIVEKIT');

print(
'🏠 ROOM NAME => '
'${newRoom.name}',
);

final localParticipant =
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

// =========================================
// ENABLE CAMERA IF PERMISSION IS GRANTED
// =========================================
if (cameraPermission.isGranted) {
try {
await localParticipant.setCameraEnabled(true);

print('📷 CAMERA ENABLED');
} catch (e) {
/*
           * فشل تشغيل الكاميرا لا يفصل المستخدم
           * من الغرفة.
           */
print(
'⚠️ CAMERA ENABLE ERROR => $e',
);
}
} else {
print(
'⚠️ CAMERA NOT ENABLED: '
'PERMISSION DENIED',
);
}

// =========================================
// ENABLE MICROPHONE IF PERMISSION IS GRANTED
// =========================================
if (microphonePermission.isGranted) {
try {
await localParticipant
    .setMicrophoneEnabled(true);

print('🎤 MICROPHONE ENABLED');
} catch (e) {
/*
           * فشل تشغيل الميكروفون لا يفصل المستخدم
           * من الغرفة.
           */
print(
'⚠️ MICROPHONE ENABLE ERROR => $e',
);
}
} else {
print(
'⚠️ MICROPHONE NOT ENABLED: '
'PERMISSION DENIED',
);
}

// =========================================
// EMIT CONNECTED STATE
// =========================================
_handleJoinLeft();
_emitParticipants();

print('✅ LIVEKIT INIT COMPLETED');
} catch (e, stackTrace) {
print('❌ LIVEKIT ERROR => $e');
print('❌ STACK TRACE => $stackTrace');

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
e.toString(),
),
);
}

/*
       * مهم جدًا:
       * إرسال الخطأ إلى StreamFlowCubit
       * حتى لا يكمل إلى Start Stream
       * ويطبع أن LiveKit اتصل رغم فشل الاتصال.
       */
rethrow;
}
}

// =========================================
// ROOM LISTENER
// =========================================
void _onRoomUpdate() {
if (isClosed) return;

_handleJoinLeft();
_emitParticipants();
}

// =========================================
// DETECT JOINED AND LEFT PARTICIPANTS
// =========================================
void _handleJoinLeft() {
final currentRoom = _room;

if (currentRoom == null) {
return;
}

final currentParticipantIds = <String>[];

final localParticipant =
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

for (final participantId
in currentParticipantIds) {
if (!_previousParticipantIds
    .contains(participantId)) {
print(
'👤 JOINED => $participantId',
);
}
}

for (final participantId
in _previousParticipantIds) {
if (!currentParticipantIds
    .contains(participantId)) {
print(
'👤 LEFT => $participantId',
);
}
}

_previousParticipantIds
..clear()
..addAll(currentParticipantIds);
}

// =========================================
// EMIT PARTICIPANTS TO UI
// =========================================
void _emitParticipants() {
if (isClosed) return;

final currentRoom = _room;

if (currentRoom == null) {
return;
}

final localParticipant =
currentRoom.localParticipant;

/*
     * لو المستخدم لم يدخل الغرفة فعليًا بعد،
     * لا نرسل LiveKitConnected.
     */
if (localParticipant == null) {
return;
}

final participants = <Participant>[
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

// =========================================
// TOGGLE MICROPHONE
// =========================================
Future<void> toggleMic() async {
final localParticipant =
_room?.localParticipant;

if (localParticipant == null) {
print(
'⚠️ CANNOT TOGGLE MIC: '
'LOCAL PARTICIPANT IS NULL',
);

return;
}

try {
final isEnabled =
localParticipant.isMicrophoneEnabled();

await localParticipant
    .setMicrophoneEnabled(!isEnabled);

print(
'🎤 MICROPHONE ENABLED => '
'${!isEnabled}',
);

_emitParticipants();
} catch (e) {
print('❌ TOGGLE MIC ERROR => $e');

if (!isClosed) {
emit(
LiveKitError(
'Toggle microphone failed: $e',
),
);
}
}
}

// =========================================
// TOGGLE CAMERA
// =========================================
Future<void> toggleCamera() async {
final localParticipant =
_room?.localParticipant;

if (localParticipant == null) {
print(
'⚠️ CANNOT TOGGLE CAMERA: '
'LOCAL PARTICIPANT IS NULL',
);

return;
}

try {
final isEnabled =
localParticipant.isCameraEnabled();

await localParticipant
    .setCameraEnabled(!isEnabled);

print(
'📷 CAMERA ENABLED => '
'${!isEnabled}',
);

_emitParticipants();
} catch (e) {
print('❌ TOGGLE CAMERA ERROR => $e');

if (!isClosed) {
emit(
LiveKitError(
'Toggle camera failed: $e',
),
);
}
}
}

// =========================================
// DISCONNECT FROM LIVEKIT
// =========================================
Future<void> disconnect() async {
try {
print('❌ DISCONNECTING LIVEKIT');

await _clearRoom();

if (!isClosed) {
emit(LiveKitInitial());
}

print('✅ LIVEKIT DISCONNECTED');
} catch (e, stackTrace) {
print(
'❌ LIVEKIT DISCONNECT ERROR => $e',
);

print(
'❌ STACK TRACE => $stackTrace',
);

if (!isClosed) {
emit(
LiveKitError(
'Disconnect failed: $e',
),
);
}
}
}

// =========================================
// CLEAR CURRENT ROOM
// =========================================
Future<void> _clearRoom() async {
final currentRoom = _room;

/*
     * نخلي القيمة null أولًا حتى لا تستخدم
     * باقي الدوال Room أثناء عملية الفصل.
     */
_room = null;

_previousParticipantIds.clear();

if (currentRoom == null) {
return;
}

currentRoom.removeListener(
_onRoomUpdate,
);

await currentRoom.disconnect();
}

// =========================================
// CLOSE CUBIT
// =========================================
@override
Future<void> close() async {
try {
await _clearRoom();
} catch (e) {
print(
'⚠️ LIVEKIT CLOSE ERROR => $e',
);
}

return super.close();
}
}
