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

  Future<void> startFullFlow({
    required int accountId,
    required String name,
    required String description,
    required String layoutType,
    required String csrfToken,
    required String authToken,
    required String facebookRtmpUrl,
    required String facebookRtmpKey,
    String facebookStreamUrl = "https://www.facebook.com",
  }) async {
    // ============================================================
    // PREVENT DUPLICATE FLOW
    // ============================================================

    if (state is StreamFlowLoading) {
      print("⚠️ STREAM FLOW ALREADY RUNNING");
      return;
    }

    emit(StreamFlowLoading());

    try {
      print("");
      print("======================================");
      print("🚀 FACEBOOK STREAM FLOW STARTED");
      print("======================================");

      // ============================================================
      // VALIDATION
      // ============================================================

      if (facebookRtmpUrl.trim().isEmpty) {
        emit(
          StreamFlowError(
            "Facebook RTMP URL is empty",
          ),
        );
        return;
      }

      if (facebookRtmpKey.trim().isEmpty) {
        emit(
          StreamFlowError(
            "Facebook Stream Key is empty",
          ),
        );
        return;
      }

      if (accountId <= 0) {
        emit(
          StreamFlowError(
            "Invalid account ID",
          ),
        );
        return;
      }

      print("✅ BASIC VALIDATION PASSED");

      // ============================================================
      // AUTH TOKEN
      // ============================================================

      final finalAuthToken = authToken.trim().isNotEmpty
          ? authToken.trim()
          : (await StorageHelper.getToken()) ?? "";

      if (finalAuthToken.trim().isEmpty) {
        emit(
          StreamFlowError(
            "Auth token is empty",
          ),
        );
        return;
      }

      print("✅ AUTH TOKEN FOUND");

      if (csrfToken.trim().isNotEmpty) {
        print("✅ CSRF TOKEN PROVIDED");
      } else {
        print("ℹ️ CSRF TOKEN NOT PROVIDED");
      }

      // ============================================================
      // STEP 1: CREATE STREAM
      // POST /api/streams/streams/
      // ============================================================

      print("");
      print("======================================");
      print("1️⃣ CREATING STREAM...");
      print("======================================");

      final stream = await streamCubit.createStream(
        name: name,
        description: description,
        layoutType: layoutType,
      );

      if (stream == null) {
        emit(
          StreamFlowError(
            "Stream creation failed",
          ),
        );
        return;
      }

      final streamId = _extractStreamId(stream);

      if (streamId == null || streamId <= 0) {
        print("❌ STREAM ID NOT FOUND");

        emit(
          StreamFlowError(
            "Stream ID not found in create stream response",
          ),
        );

        return;
      }

      print("✅ STREAM CREATED");
      print("🆔 STREAM ID => $streamId");

      // ============================================================
      // STEP 2: CREATE FACEBOOK DESTINATION
      // POST /api/streams/destinations/
      // ============================================================

      print("");
      print("======================================");
      print("2️⃣ CREATING FACEBOOK DESTINATION...");
      print("======================================");

      final destination = await destinationCubit.createDestination(
        name: "Facebook",
        platformType: "facebook",
        rtmpUrl: facebookRtmpUrl.trim(),
        rtmpKey: facebookRtmpKey.trim(),
        streamUrl: facebookStreamUrl.trim(),
      );

      if (destination == null || destination.id == null) {
        emit(
          StreamFlowError(
            "Facebook destination creation failed",
          ),
        );
        return;
      }

      final destinationId = destination.id!;

      print("✅ FACEBOOK DESTINATION CREATED");
      print("🆔 DESTINATION ID => $destinationId");

      // ============================================================
      // STEP 3: CONNECT FACEBOOK DESTINATION
      // POST /api/streams/destinations/{id}/connect/
      // ============================================================

      print("");
      print("======================================");
      print("3️⃣ CONNECTING FACEBOOK DESTINATION...");
      print("======================================");

      final connect = await connectCubit.connectDestination(
        destinationId: destinationId,
        accountId: accountId,
        name: name,
        platformType: "facebook",
        rtmpKey: facebookRtmpKey.trim(),
        streamUrl: facebookStreamUrl.trim(),
      );

      if (connect == null) {
        emit(
          StreamFlowError(
            "Connect Facebook destination failed",
          ),
        );
        return;
      }

      print("✅ FACEBOOK DESTINATION CONNECTED");

      // ============================================================
      // STEP 4: ATTACH DESTINATION TO STREAM
      // POST /api/streams/streams/{id}/destinations/
      // ============================================================

      print("");
      print("======================================");
      print("4️⃣ ATTACHING FACEBOOK DESTINATION...");
      print("======================================");

      final attach = await attachCubit.attachDestination(
        streamId: streamId,
        destinationId: destinationId,
      );

      if (attach == null) {
        emit(
          StreamFlowError(
            "Attach Facebook destination failed",
          ),
        );
        return;
      }

      print("✅ FACEBOOK DESTINATION ATTACHED");
      print("📺 STREAM ID => $streamId");
      print("🔗 DESTINATION ID => $destinationId");

      // ============================================================
      // STEP 5: GET HOST TOKEN
      // POST /api/streams/streams/{id}/host-token/
      //
      // مهم:
      // هنا نستخدم HostTokenCubit
      // ولا نطلب Guest Token
      // ============================================================

      print("");
      print("======================================");
      print("5️⃣ GETTING HOST TOKEN...");
      print("======================================");

      // ============================================================
// STEP 5: GET HOST TOKEN
// ============================================================

      print("");
      print("======================================");
      print("5️⃣ GETTING HOST TOKEN...");
      print("======================================");

      await hostTokenCubit.getHostToken(
        id: streamId,
        accountId: accountId,
        name: name,
        description: description,
        layoutType: layoutType,
      );

      final hostState = hostTokenCubit.state;

      if (hostState is HostTokenError) {
        print(
          "❌ HOST TOKEN ERROR => ${hostState.error}",
        );

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
            "Failed to get host token",
          ),
        );

        return;
      }

      final hostModel = hostState.model;

      final liveKitToken =
      hostModel.livekitToken.trim();

      final liveKitUrl =
      hostModel.livekitUrl.trim();

      final roomName =
      hostModel.roomName.trim();

      if (liveKitToken.isEmpty) {
        emit(
          StreamFlowError(
            "Host LiveKit token is empty",
          ),
        );

        return;
      }

      if (liveKitUrl.isEmpty) {
        emit(
          StreamFlowError(
            "Host LiveKit URL is empty",
          ),
        );

        return;
      }

      print("✅ HOST TOKEN RECEIVED");
      print("🌍 LIVEKIT URL => $liveKitUrl");
      print("🏠 ROOM NAME => $roomName");

// ============================================================
// CONNECT TO LIVEKIT AS HOST
// ============================================================

      print("");
      print("======================================");
      print("🎥 CONNECTING TO LIVEKIT AS HOST...");
      print("======================================");

      await liveKitCubit.init(
        url: liveKitUrl,
        token: liveKitToken,
      );

      final participant =
          liveKitCubit.room?.localParticipant;

      if (participant == null) {
        emit(
          StreamFlowError(
            "LiveKit local host participant not found",
          ),
        );

        return;
      }

      print("✅ CONNECTED TO LIVEKIT AS HOST");

      print(
        "👤 HOST PARTICIPANT => "
            "${participant.identity}",
      );

      final isCameraOn =
      participant.isCameraEnabled();

      final isMicOn =
      participant.isMicrophoneEnabled();

      print(
        "📷 HOST CAMERA STATUS => $isCameraOn",
      );

      print(
        "🎤 HOST MICROPHONE STATUS => $isMicOn",
      );

      if (!isCameraOn) {
        emit(
          StreamFlowError(
            "Host camera not published",
          ),
        );

        return;
      }

      if (!isMicOn) {
        emit(
          StreamFlowError(
            "Host microphone not published",
          ),
        );

        return;
      }

      print(
        "✅ HOST CAMERA AND MICROPHONE PUBLISHED",
      );

      // ============================================================
      // STEP 6: START FACEBOOK STREAM
      // POST /api/streams/streams/{id}/start/
      // ============================================================

      print("");
      print("======================================");
      print("6️⃣ STARTING FACEBOOK STREAM...");
      print("======================================");

      final started = await startStreamCubit.startStream(
        streamId: streamId,
        model: StartStreamModel(
          accountId: accountId,
          name: name,
          description: description,
          layoutType: layoutType,
        ),
      );

      if (started == null) {
        print("❌ START FACEBOOK STREAM FAILED");

        emit(
          StreamFlowError(
            "Start Facebook stream failed",
          ),
        );

        return;
      }

      print("");
      print("======================================");
      print("🎬 FACEBOOK STREAM STARTED SUCCESSFULLY");
      print("======================================");

      emit(
        StreamFlowSuccess(
          "Facebook stream started successfully 🚀",
        ),
      );
    } catch (e, stackTrace) {
      print("");
      print("======================================");
      print("❌ FACEBOOK FLOW ERROR");
      print("======================================");

      print("❌ ERROR => $e");
      print("📚 STACK TRACE => $stackTrace");

      emit(
        StreamFlowError(
          e.toString(),
        ),
      );
    }
  }

  // ==============================================================
  // EXTRACT STREAM ID
  // ==============================================================

  int? _extractStreamId(dynamic stream) {
    if (stream == null) {
      return null;
    }

    // Map
    if (stream is Map) {
      final value = stream['id'];

      if (value is int) {
        return value;
      }

      return int.tryParse(
        value?.toString() ?? "",
      );
    }

    // Object property: stream.id
    try {
      final dynamic object = stream;
      final value = object.id;

      if (value is int) {
        return value;
      }

      final parsed = int.tryParse(
        value?.toString() ?? "",
      );

      if (parsed != null) {
        return parsed;
      }
    } catch (_) {}

    // Object toJson()
    try {
      final dynamic object = stream;
      final json = object.toJson();

      if (json is Map) {
        final value = json['id'];

        if (value is int) {
          return value;
        }

        return int.tryParse(
          value?.toString() ?? "",
        );
      }
    } catch (_) {}

    return null;
  }

  // ==============================================================
  // EXTRACT HOST CREDENTIALS FROM HOST TOKEN STATE
  // ==============================================================

  _HostLiveKitCredentials? _extractHostCredentialsFromState(
      dynamic hostState,
      ) {
    if (hostState == null) {
      return null;
    }

    dynamic model;

    // ------------------------------------------------------------
    // Try: state.model
    // ------------------------------------------------------------

    try {
      model = hostState.model;
    } catch (_) {}

    // ------------------------------------------------------------
    // Try: state.data
    // ------------------------------------------------------------

    if (model == null) {
      try {
        model = hostState.data;
      } catch (_) {}
    }

    // ------------------------------------------------------------
    // Try: state.hostTokenModel
    // ------------------------------------------------------------

    if (model == null) {
      try {
        model = hostState.hostTokenModel;
      } catch (_) {}
    }

    // ------------------------------------------------------------
    // Try extracting directly from state itself
    // ------------------------------------------------------------

    if (model == null) {
      model = hostState;
    }

    return _extractHostCredentials(
      model,
      depth: 0,
    );
  }

  // ==============================================================
  // RECURSIVE HOST CREDENTIALS EXTRACTOR
  // ==============================================================

  _HostLiveKitCredentials? _extractHostCredentials(
      dynamic source, {
        required int depth,
      }) {
    if (source == null) {
      return null;
    }

    // منع recursion لا نهائي
    if (depth > 5) {
      return null;
    }

    String? token;
    String? url;
    String? roomName;

    // ============================================================
    // CASE 1: SOURCE IS MAP
    // ============================================================

    if (source is Map) {
      token = _firstNonEmptyString([
        source['livekit_token'],
        source['liveKitToken'],
        source['livekitToken'],
        source['token'],
      ]);

      url = _firstNonEmptyString([
        source['livekit_url'],
        source['liveKitUrl'],
        source['livekitUrl'],
        source['url'],
      ]);

      roomName = _firstNonEmptyString([
        source['room_name'],
        source['roomName'],
      ]);

      // لو وجدنا token + url
      if (token != null && url != null) {
        return _HostLiveKitCredentials(
          token: token,
          url: url,
          roomName: roomName,
        );
      }

      // ----------------------------------------------------------
      // Nested structures
      // ----------------------------------------------------------

      final nestedCandidates = [
        source['data'],
        source['host_token'],
        source['hostToken'],
        source['model'],
        source['result'],
      ];

      for (final candidate in nestedCandidates) {
        final credentials = _extractHostCredentials(
          candidate,
          depth: depth + 1,
        );

        if (credentials != null) {
          return credentials;
        }
      }
    }

    // ============================================================
    // CASE 2: OBJECT PROPERTIES
    // ============================================================

    try {
      final dynamic object = source;

      token = _firstNonEmptyString([
        object.livekitToken,
      ]);
    } catch (_) {}

    if (token == null) {
      try {
        final dynamic object = source;

        token = _firstNonEmptyString([
          object.liveKitToken,
        ]);
      } catch (_) {}
    }

    if (url == null) {
      try {
        final dynamic object = source;

        url = _firstNonEmptyString([
          object.livekitUrl,
        ]);
      } catch (_) {}
    }

    if (url == null) {
      try {
        final dynamic object = source;

        url = _firstNonEmptyString([
          object.liveKitUrl,
        ]);
      } catch (_) {}
    }

    if (roomName == null) {
      try {
        final dynamic object = source;

        roomName = _firstNonEmptyString([
          object.roomName,
        ]);
      } catch (_) {}
    }

    if (token != null && url != null) {
      return _HostLiveKitCredentials(
        token: token,
        url: url,
        roomName: roomName,
      );
    }

    // ============================================================
    // CASE 3: OBJECT.toJson()
    // ============================================================

    try {
      final dynamic object = source;
      final json = object.toJson();

      final credentials = _extractHostCredentials(
        json,
        depth: depth + 1,
      );

      if (credentials != null) {
        return credentials;
      }
    } catch (_) {}

    // ============================================================
    // CASE 4: NESTED OBJECT PROPERTIES
    // ============================================================

    final nestedObjects = <dynamic>[];

    try {
      final dynamic object = source;
      nestedObjects.add(object.data);
    } catch (_) {}

    try {
      final dynamic object = source;
      nestedObjects.add(object.hostToken);
    } catch (_) {}

    try {
      final dynamic object = source;
      nestedObjects.add(object.model);
    } catch (_) {}

    for (final nested in nestedObjects) {
      final credentials = _extractHostCredentials(
        nested,
        depth: depth + 1,
      );

      if (credentials != null) {
        return credentials;
      }
    }

    return null;
  }

  // ==============================================================
  // EXTRACT HOST TOKEN ERROR MESSAGE
  // ==============================================================

  String _extractHostTokenErrorMessage(
      dynamic hostState,
      ) {
    if (hostState == null) {
      return "Host token failed";
    }

    try {
      final dynamic state = hostState;
      final message = state.message?.toString();

      if (message != null &&
          message.trim().isNotEmpty) {
        return message.trim();
      }
    } catch (_) {}

    try {
      final dynamic state = hostState;
      final error = state.error?.toString();

      if (error != null &&
          error.trim().isNotEmpty) {
        return error.trim();
      }
    } catch (_) {}

    return "Host token failed";
  }

  // ==============================================================
  // FIRST NON-EMPTY STRING
  // ==============================================================

  String? _firstNonEmptyString(
      List<dynamic> values,
      ) {
    for (final value in values) {
      if (value == null) {
        continue;
      }

      final stringValue = value.toString().trim();

      if (stringValue.isNotEmpty &&
          stringValue.toLowerCase() != "null") {
        return stringValue;
      }
    }

    return null;
  }
}

// ================================================================
// PRIVATE HOST LIVEKIT CREDENTIALS
// ================================================================

class _HostLiveKitCredentials {
  const _HostLiveKitCredentials({
    required this.token,
    required this.url,
    this.roomName,
  });

  final String token;
  final String url;
  final String? roomName;
}