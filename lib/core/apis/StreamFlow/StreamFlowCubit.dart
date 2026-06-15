import 'package:bloc/bloc.dart';
import 'package:streamore_app/core/apis/StreamFlow/StreamFlowState.dart';
import 'package:streamore_app/core/apis/connect_des/connect_destination_cubit.dart';
import 'package:streamore_app/core/apis/destination/destination_cubit.dart';
import 'package:streamore_app/core/apis/live_token%20/bloc/LiveKitTokenCubit.dart';
import 'package:streamore_app/core/apis/start/start_stream_cubit.dart';
import 'package:streamore_app/core/apis/start/start_stream_model.dart';
import 'package:streamore_app/core/apis/stream_des/stream_destinations_cubit.dart';
import 'package:streamore_app/core/apis/streams/stream_cubit.dart';
import 'package:streamore_app/core/apis/live_token /bloc/livekit_token_states.dart';
import 'package:streamore_app/core/helpers/storage_helper.dart';
import 'package:streamore_app/features/livekit/bloc/livekit_cubit.dart';

class StreamFlowCubit extends Cubit<StreamFlowState> {
  StreamFlowCubit({
    required this.streamCubit,
    required this.destinationCubit,
    required this.connectCubit,
    required this.attachCubit,
    required this.liveKitTokenCubit,
    required this.startStreamCubit,
    required this.liveKitCubit,
  }) : super(StreamFlowInitial());

  final StreamCubit streamCubit;
  final DestinationCubit destinationCubit;
  final ConnectDestinationCubit connectCubit;
  final StreamDestinationsCubit attachCubit;
  final LiveKitTokenCubit liveKitTokenCubit;
  final StartStreamCubit startStreamCubit;
  final LiveKitCubit liveKitCubit;

  Future<void> startFullFlow({
    required int accountId,
    required String name,
    required String description,
    required String layoutType,
    required String csrfToken,
    required String authToken,
  }) async {
    emit(StreamFlowLoading());

    try {
      print("\n============================");
      print("🚀 FLOW STARTED");
      print("============================\n");

      /// =======================
      /// STEP 1: STREAM
      /// =======================
      print("📡 STEP 1: Creating Stream...");

      final stream = await streamCubit.createStream(
        name: name,
        description: description,
        layoutType: layoutType,
      );

      print("📡 STREAM RESPONSE: $stream");

      if (stream == null) {
        print("❌ STREAM NULL");
        emit(StreamFlowError("Stream is null"));
        return;
      }

      if (stream.id == null) {
        print("❌ STREAM ID NULL");
        emit(StreamFlowError("Stream ID is null"));
        return;
      }

      final streamId = stream.id!;
      print("✅ STREAM ID => $streamId");

      /// =======================
      /// STEP 2: DESTINATION
      /// =======================
      print("\n📡 STEP 2: Creating Destination...");

      final destination = await destinationCubit.createDestination(
        name: "YouTube",
        platformType: "youtube",
        rtmpUrl: "rtmp://a.rtmp.youtube.com/live2",
        rtmpKey: "test_rtmp_key_12345",
        streamUrl: "https://youtube.com",
      );

      print("📡 DESTINATION RESPONSE: $destination");

      if (destination == null) {
        print("❌ DESTINATION NULL");
        emit(StreamFlowError("Destination is null"));
        return;
      }

      if (destination.id == null) {
        print("❌ DESTINATION ID NULL");
        emit(StreamFlowError("Destination ID is null"));
        return;
      }

      final destinationId = destination.id!;
      print("✅ DESTINATION ID => $destinationId");

      /// =======================
      /// STEP 3: CONNECT
      /// =======================
      print("\n📡 STEP 3: Connecting Destination...");

      final connect = await connectCubit.connectDestination(
        destinationId: destinationId,
        accountId: accountId,
        name: name,
        platformType: "youtube",
        rtmpKey: "test_rtmp_key_12345",
        streamUrl: "https://youtube.com",
      );

      print("📡 CONNECT RESPONSE: $connect");

      if (connect == null) {
        print("❌ CONNECT FAILED");
        emit(StreamFlowError("Connect failed"));
        return;
      }

      print("✅ CONNECT SUCCESS");

      /// =======================
      /// STEP 4: ATTACH
      /// =======================
      print("\n📡 STEP 4: Attaching Destination...");

      final attach = await attachCubit.attachDestination(
        streamId: streamId,
        destinationId: destinationId,
      );

      print("📡 ATTACH RESPONSE: $attach");

      if (attach == null) {
        print("❌ ATTACH FAILED");
        emit(StreamFlowError("Attach failed"));
        return;
      }

      print("✅ ATTACH SUCCESS");

      /// =======================
      /// STEP 5: LIVEKIT TOKEN
      /// =======================
      print("\n📡 STEP 5: LiveKit Token Request...");

      final token = await StorageHelper.getToken();
      final csrf = await StorageHelper.getCsrf(); // لو موجود

      print("🔥 TOKEN FROM STORAGE => $token");
      print("🔥 CSRF FROM STORAGE => $csrf");

      await liveKitTokenCubit.createLiveKitToken(
        streamId: streamId,
        accountId: accountId,
        name: name,
        description: description,
        layoutType: layoutType,
        csrfToken: csrf ?? "",   // fallback مهم
        authToken: token ?? "",
      );
      print("🔥 FINAL LIVEKIT INPUTS");
      print("streamId: $streamId");
      print("accountId: $accountId");
      print("csrf: $csrfToken");
      print("auth: $authToken");

      print("📡 LIVEKIT STATE: ${liveKitTokenCubit.state}");

      final state = liveKitTokenCubit.state;

      if (state is! LiveKitTokenSuccess) {
        print("❌ LIVEKIT TOKEN FAILED STATE: $state");
        emit(StreamFlowError("LiveKit token failed"));
        return;
      }

      final token = state.data;

      print("📡 LIVEKIT TOKEN MODEL: $token");
      print("📡 URL: ${token.livekitUrl}");
      print("📡 TOKEN: ${token.livekitToken}");

      if (token.livekitUrl == null || token.livekitToken == null) {
        print("❌ LIVEKIT DATA INVALID");
        emit(StreamFlowError("Invalid LiveKit data"));
        return;
      }

      print("✅ LIVEKIT READY");

      /// =======================
      /// STEP 6: START STREAM
      /// =======================
      print("\n📡 STEP 6: Starting Stream...");

      final start = await startStreamCubit.startStream(
        streamId: streamId,
        model: StartStreamModel(
          accountId: accountId,
          name: name,
          description: description,
          layoutType: layoutType,
        ),
      );

      print("📡 START STREAM RESPONSE: $start");

      if (start == null) {
        print("❌ START STREAM FAILED");
        emit(StreamFlowError("Start stream failed"));
        return;
      }

      print("✅ STREAM STARTED");

      /// =======================
      /// STEP 7: LIVEKIT JOIN
      /// =======================
      print("\n📡 STEP 7: Joining LiveKit...");

      await liveKitCubit.init(
        url: token.livekitUrl!,
        token: token.livekitToken!,
      );

      print("🎉 LIVEKIT JOINED SUCCESSFULLY");

      /// =======================
      /// SUCCESS
      /// =======================
      print("\n🎉 FLOW COMPLETED SUCCESSFULLY 🎉\n");

      emit(StreamFlowSuccess("Stream started successfully 🚀"));
    } catch (e, s) {
      print("❌ GLOBAL ERROR: $e");
      print("STACK TRACE: $s");
      emit(StreamFlowError(e.toString()));
    }
  }
}