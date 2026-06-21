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
import 'package:streamore_app/features/livekit/bloc/livekit_state.dart';

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
      print("\n🚀 FLOW STARTED");

      /// =======================
      /// STEP 1: CREATE STREAM
      /// =======================
      final stream = await streamCubit.createStream(
        name: name,
        description: description,
        layoutType: layoutType,
      );

      if (stream == null || stream.id == null) {
        emit(StreamFlowError("Stream creation failed"));
        return;
      }

      final streamId = stream.id!;

      print("✅ STREAM CREATED => $streamId");

      /// =======================
      /// STEP 2: GET LIVEKIT TOKEN
      /// =======================
      final auth = await StorageHelper.getToken();
      final csrf = await StorageHelper.getCsrf();

      await liveKitTokenCubit.createLiveKitToken(
        streamId: streamId,
        accountId: accountId,
        name: name,
        description: description,
        layoutType: layoutType,
        csrfToken: csrf ?? "",
        authToken: auth ?? "",
      );

      final tokenState = liveKitTokenCubit.state;

      if (tokenState is! LiveKitTokenSuccess) {
        emit(StreamFlowError("LiveKit token failed"));
        return;
      }

      final liveKitData = tokenState.data;

      print("URL => ${liveKitData.livekitUrl}");
      print("TOKEN => ${liveKitData.livekitToken}");
      //print("ROOM => ${liveKitData.roomName}");

      /// =======================
      /// STEP 3: CONNECT LIVEKIT
      /// =======================
      await liveKitCubit.init(
        url: liveKitData.livekitUrl!,
        token: liveKitData.livekitToken!,
      );

      /// ✅ FIX: liveKitCubit.init() بيستنى لحد ما يخلص تمامًا قبل ما يرجع،
      /// يعني كل الـ states بتاعته (Loading/Error/Connected) اتعملها emit
      /// وخلصت قبل ما نوصل هنا. فمفيش داعي نستنى event جديد من الـ stream
      /// (ده كان بيسبب hang للأبد). إحنا بس بنقرا الـ state الحالي مباشرة.
      final currentLiveKitState = liveKitCubit.state;

      if (currentLiveKitState is LiveKitError) {
        emit(StreamFlowError("LiveKit connection failed"));
        return;
      }

      if (currentLiveKitState is! LiveKitConnected) {
        emit(StreamFlowError("LiveKit did not reach connected state"));
        return;
      }

      print("🎥 LIVEKIT CONNECTED (CONFIRMED)");

      /// =======================
      /// STEP 4: CREATE DESTINATION
      /// =======================
      final destination = await destinationCubit.createDestination(
        name: "YouTube",
        platformType: "youtube",
        rtmpUrl: "rtmp://a.rtmp.youtube.com/live2",
        rtmpKey: "test_rtmp_key_12345",
        streamUrl: "https://youtube.com",
      );

      if (destination == null || destination.id == null) {
        emit(StreamFlowError("Destination creation failed"));
        return;
      }

      final destinationId = destination.id!;

      print("✅ DESTINATION CREATED => $destinationId");

      /// =======================
      /// STEP 5: CONNECT DESTINATION
      /// =======================
      final connect = await connectCubit.connectDestination(
        destinationId: destinationId,
        accountId: accountId,
        name: name,
        platformType: "youtube",
        rtmpKey: "test_rtmp_key_12345",
        streamUrl: "https://youtube.com",
      );

      if (connect == null) {
        emit(StreamFlowError("Connect destination failed"));
        return;
      }

      print("✅ DESTINATION CONNECTED");

      /// =======================
      /// STEP 6: ATTACH DESTINATION
      /// =======================
      final attach = await attachCubit.attachDestination(
        streamId: streamId,
        destinationId: destinationId,
      );

      if (attach == null) {
        emit(StreamFlowError("Attach destination failed"));
        return;
      }

      print("✅ DESTINATION ATTACHED");

      /// =======================
      /// STEP 7: START STREAM
      /// =======================
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
        emit(StreamFlowError("Start stream failed"));
        return;
      }

      print("🎬 STREAM STARTED SUCCESSFULLY");

      emit(
        StreamFlowSuccess(
          "Stream started successfully 🚀",
        ),
      );
    } catch (e) {
      print("❌ FLOW ERROR => $e");

      emit(
        StreamFlowError(
          e.toString(),
        ),
      );
    }
  }
}