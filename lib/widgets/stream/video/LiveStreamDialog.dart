import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamore_app/core/apis/StreamFlow/StreamFlowCubit.dart';
import 'package:streamore_app/core/apis/StreamFlow/StreamFlowState.dart';
import 'package:streamore_app/core/apis/connect_des/connect_destination_cubit.dart';
import 'package:streamore_app/core/apis/connect_des/connect_destination_state.dart';
import 'package:streamore_app/core/apis/destination/destination_cubit.dart';
import 'package:streamore_app/core/apis/live_token%20/bloc/LiveKitTokenCubit.dart';
import 'package:streamore_app/core/apis/start/start_stream_cubit.dart';
import 'package:streamore_app/core/apis/start/start_stream_model.dart';
import 'package:streamore_app/core/apis/stream_des/stream_destinations_cubit.dart';
import 'package:streamore_app/core/apis/streams/stream_cubit.dart';
import 'package:streamore_app/features/livekit/bloc/LiveKitResponse.dart';
import 'package:streamore_app/features/livekit/bloc/livekit_cubit.dart';

import '../../../core/apis/live_token /bloc/livekit_token_model.dart' as livekit;

class LiveStreamDialog extends StatefulWidget {
  const LiveStreamDialog({super.key});

  @override
  State<LiveStreamDialog> createState() => _LiveStreamDialogState();
}

class _LiveStreamDialogState extends State<LiveStreamDialog> {
  String selectedSource = "live".tr();
  bool isDestinationPage = false;

  @override
  void initState() {
    super.initState();
    // ❌ removed getLiveKitData (was undefined)
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black87;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: width * 0.045,
      ),
      backgroundColor: isDark ? const Color(0xFF071332) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width * 0.045),
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(width * 0.045),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF071332) : Colors.white,
          borderRadius: BorderRadius.circular(width * 0.045),
          border: Border.all(color: const Color(0xFF17356E)),
        ),
        child: isDestinationPage
            ? _buildDestinationPage(
          context,
          width,
          height,
          isDark,
          textColor,
          secondaryTextColor,
        )
            : _buildLivePage(
          context,
          width,
          height,
          isDark,
          textColor,
          secondaryTextColor,
        ),
      ),
    );
  }

  Widget _buildLivePage(
      BuildContext context,
      double width,
      double height,
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  try {
                    print("🔥 START STREAM CLICKED");

                    final response =
                    await context.read<StartStreamCubit>().startStream(
                      streamId: 4,
                      model: StartStreamModel(
                        accountId: 1,
                        name: "My Stream",
                        description: "Testing",
                        layoutType: "user",
                      ),
                    );

                    /// ✅ الحل الصحيح: التعامل مع response.data أو response مباشرة
                    final dataMap = response as Map<String, dynamic>;

                    final model = LiveKitResponse.fromJson(
                      dataMap['data'] ?? dataMap,
                    );

                    await context.read<LiveKitCubit>().init(
                      url: model.livekitUrl,
                      token: model.livekitToken,
                    );

                    print("✅ LIVE STARTED");
                  } catch (e) {
                    print("❌ STREAM ERROR => $e");
                  }
                },
                child: Text(
                  "start_live_stream".tr(),
                  style: TextStyle(
                    color: textColor,
                    fontSize: width * 0.055,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.close,
                color: secondaryTextColor,
                size: width * 0.06,
              ),
            ),
          ],
        ),

        SizedBox(height: height * 0.01),

        Text(
          "live_stream_description".tr(),
          style: TextStyle(
            color: const Color(0xFF8EB5E4),
            fontSize: width * 0.035,
          ),
        ),

        SizedBox(height: height * 0.028),

        Text(
          "source".tr(),
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: width * 0.038,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: height * 0.018),

        Wrap(
          spacing: width * 0.045,
          children: [
            _radioOption("live".tr(), textColor, width),
            _radioOption("pre_recorded_video".tr(), textColor, width),
          ],
        ),

        SizedBox(height: height * 0.03),

        Column(
          children: [
            Center(
              child: SizedBox(
                width: width * 0.50,
                height: height * 0.055,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF1D6EFF)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isDestinationPage = true;
                    });
                  },
                  icon: Icon(Icons.add,
                      color: const Color(0xFF1D6EFF), size: width * 0.05),
                  label: Text(
                    "add_destination".tr(),
                    style: TextStyle(
                      color: const Color(0xFF1D6EFF),
                      fontSize: width * 0.038,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.012),
            Center(
              child: SizedBox(
                width: width * 0.50,
                height: height * 0.055,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D6EFF),
                  ),
                  onPressed: () async {
                    await context.read<StartStreamCubit>().startStream(
                      streamId: 4,
                      model: StartStreamModel(
                        accountId: 1,
                        name: "My Stream",
                        description: "Testing",
                        layoutType: "user",
                      ),
                    );
                  },
                  child: Text(
                    "start_streaming".tr(),
                    style: TextStyle(
                      fontSize: width * 0.038,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.008),
            BlocConsumer<StreamFlowCubit, StreamFlowState>(
              listener: (context, state) {
                if (state is StreamFlowSuccess) {
                  print("✅ ${state.message}");
                }

                if (state is StreamFlowError) {
                  print("❌ ${state.error}");
                }
              },

              builder: (context, state) {
                final isLoading = state is StreamFlowLoading;

                return TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
                    context.read<StreamFlowCubit>().startFullFlow(
                      accountId: 4,
                      name: "Test Stream",
                      description: "Testing stream",
                      layoutType: "user",

                      /// ❌ بلاش YOUR_CSRF / YOUR_TOKEN
                      /// خليه يجيبهم من StorageHelper جوه الكيوبت
                      csrfToken: "",
                      authToken: "",
                    );
                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text("START STREAM"),
                );
              },
            )          ],
        ),
      ],
    );
  }

  Widget _buildDestinationPage(
      BuildContext context,
      double width,
      double height,
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "add_destination".tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isDestinationPage = false;
                });
              },
              child: Text("back".tr()),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.close, color: secondaryTextColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _radioOption(String value, Color textColor, double width) {
    final isSelected = selectedSource == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSource = value;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width * 0.045,
            height: width * 0.045,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1D6EFF)),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: width * 0.022,
                height: width * 0.022,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1D6EFF),
                ),
              ),
            )
                : null,
          ),
          SizedBox(width: width * 0.02),
          Text(value, style: TextStyle(color: textColor)),
        ],
      ),
    );
  }
}