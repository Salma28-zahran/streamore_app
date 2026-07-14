import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:streamore_app/core/apis/StreamFlow/StreamFlowCubit.dart';
import 'package:streamore_app/core/apis/StreamFlow/StreamFlowState.dart';

class LiveStreamDialog extends StatefulWidget {
  const LiveStreamDialog({super.key});

  @override
  State<LiveStreamDialog> createState() => _LiveStreamDialogState();
}

class _LiveStreamDialogState extends State<LiveStreamDialog> {
  String selectedSource = "live".tr();

  bool isDestinationPage = false;

  // ============================================================
  // FACEBOOK STREAM DATA
  // ============================================================

  /// Facebook Server URL / RTMP URL
  static const String facebookRtmpUrl =
      "rtmps://live-api-s.facebook.com:443/rtmp/";

  /// حطي هنا Facebook Stream Key جديد وحقيقي
  ///
  /// مهم:
  /// لا تضعي المفتاح القديم الذي تم كشفه
  /// ولا تنشريه في GitHub أو Logs
  static const String facebookRtmpKey =
      "FB-27150077064693389-0-Ab40U6T6oT__Da-9UBN6lFQJ";

  /// Facebook destination URL
  static const String facebookStreamUrl =
      "https://www.facebook.com";

  // ============================================================
  // START FULL FACEBOOK STREAM FLOW
  // ============================================================

  Future<void> _startFullStream(BuildContext context) async {
    final flowCubit = context.read<StreamFlowCubit>();

    // منع تشغيل الـ flow مرتين
    if (flowCubit.state is StreamFlowLoading) {
      debugPrint("⚠️ STREAM FLOW ALREADY RUNNING");
      return;
    }

    // ==========================================================
    // VALIDATE FACEBOOK RTMP URL
    // ==========================================================

    if (facebookRtmpUrl.trim().isEmpty) {
      debugPrint("❌ FACEBOOK RTMP URL IS EMPTY");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Facebook RTMP URL is empty",
          ),
        ),
      );

      return;
    }

    // ==========================================================
    // VALIDATE FACEBOOK STREAM KEY
    // ==========================================================

    if (facebookRtmpKey.trim().isEmpty) {
      debugPrint("❌ FACEBOOK STREAM KEY IS EMPTY");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Facebook Stream Key is empty",
          ),
        ),
      );

      return;
    }

    debugPrint("");
    debugPrint("======================================");
    debugPrint("🚀 STARTING FACEBOOK FULL FLOW");
    debugPrint("======================================");

    // لا نطبع الـ Stream Key لأنه Secret
    debugPrint("🌍 FACEBOOK RTMP URL => $facebookRtmpUrl");
    debugPrint("🔑 FACEBOOK STREAM KEY => RECEIVED");

    // ==========================================================
    // CALL STREAM FLOW CUBIT
    // ==========================================================

    await flowCubit.startFullFlow(
      // مهم:
      // استبدلي الرقم ده بعدين بالـ Account ID الحقيقي
      accountId: 3,

      name: "Test Facebook Stream",

      description: "Testing Facebook live stream",

      layoutType: "user",

      // لو فاضي StreamFlowCubit هيجيبه من StorageHelper
      csrfToken: "",

      // لو فاضي StreamFlowCubit هيجيبه من StorageHelper
      authToken: "",

      facebookRtmpUrl: facebookRtmpUrl.trim(),

      facebookRtmpKey: facebookRtmpKey.trim(),

      facebookStreamUrl: facebookStreamUrl.trim(),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final width = size.width;
    final height = size.height;

    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final textColor =
    isDark ? Colors.white : Colors.black;

    final secondaryTextColor =
    isDark ? Colors.white70 : Colors.black87;

    return BlocConsumer<StreamFlowCubit, StreamFlowState>(
      listener: (context, state) {
        if (state is StreamFlowSuccess) {
          debugPrint("✅ ${state.message}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }

        if (state is StreamFlowError) {
          debugPrint("❌ ${state.error}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: width * 0.045,
          ),
          backgroundColor: isDark
              ? const Color(0xFF071332)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              width * 0.045,
            ),
          ),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              width * 0.045,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF071332)
                  : Colors.white,
              borderRadius: BorderRadius.circular(
                width * 0.045,
              ),
              border: Border.all(
                color: const Color(0xFF17356E),
              ),
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
              state,
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // LIVE PAGE
  // ============================================================

  Widget _buildLivePage(
      BuildContext context,
      double width,
      double height,
      bool isDark,
      Color textColor,
      Color secondaryTextColor,
      StreamFlowState state,
      ) {
    final isLoading = state is StreamFlowLoading;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ======================================================
        // HEADER
        // ======================================================

        Row(
          children: [
            Expanded(
              child: Text(
                "start_live_stream".tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: width * 0.055,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: secondaryTextColor,
                size: width * 0.06,
              ),
            ),
          ],
        ),

        SizedBox(
          height: height * 0.01,
        ),

        Text(
          "live_stream_description".tr(),
          style: TextStyle(
            color: const Color(0xFF8EB5E4),
            fontSize: width * 0.035,
          ),
        ),

        SizedBox(
          height: height * 0.028,
        ),

        // ======================================================
        // SOURCE
        // ======================================================

        Text(
          "source".tr(),
          style: TextStyle(
            color: isDark
                ? Colors.white54
                : Colors.black54,
            fontSize: width * 0.038,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(
          height: height * 0.018,
        ),

        Wrap(
          spacing: width * 0.045,
          runSpacing: height * 0.01,
          children: [
            _radioOption(
              "live".tr(),
              textColor,
              width,
            ),
            _radioOption(
              "pre_recorded_video".tr(),
              textColor,
              width,
            ),
          ],
        ),

        SizedBox(
          height: height * 0.03,
        ),

        // ======================================================
        // FACEBOOK DESTINATION INFO
        // ======================================================

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(
            width * 0.035,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF0D1E45)
                : const Color(0xFFF5F8FF),
            borderRadius: BorderRadius.circular(
              width * 0.03,
            ),
            border: Border.all(
              color: const Color(0xFF17356E),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: width * 0.11,
                height: width * 0.11,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1877F2),
                ),
                child: Icon(
                  Icons.facebook,
                  color: Colors.white,
                  size: width * 0.07,
                ),
              ),

              SizedBox(
                width: width * 0.03,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Facebook",
                      style: TextStyle(
                        color: textColor,
                        fontSize: width * 0.043,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.004,
                    ),
                    Text(
                      "RTMP destination ready",
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: width * 0.032,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.check_circle,
                color: Colors.green,
              ),
            ],
          ),
        ),

        SizedBox(
          height: height * 0.025,
        ),

        // ======================================================
        // ADD DESTINATION BUTTON
        // ======================================================

        Center(
          child: SizedBox(
            width: width * 0.55,
            height: height * 0.055,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xFF1D6EFF),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    width * 0.03,
                  ),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                setState(() {
                  isDestinationPage = true;
                });
              },
              icon: Icon(
                Icons.add,
                color: const Color(0xFF1D6EFF),
                size: width * 0.05,
              ),
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

        SizedBox(
          height: height * 0.014,
        ),

        // ======================================================
        // START STREAM BUTTON
        // ======================================================

        Center(
          child: SizedBox(
            width: width * 0.55,
            height: height * 0.06,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF1D6EFF),
                disabledBackgroundColor:
                const Color(0xFF1D6EFF)
                    .withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    width * 0.03,
                  ),
                ),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                await _startFullStream(context);
              },
              child: isLoading
                  ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                "start_streaming".tr(),
                style: TextStyle(
                  fontSize: width * 0.038,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DESTINATION PAGE
  // ============================================================

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
      crossAxisAlignment:
      CrossAxisAlignment.start,
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

            TextButton(
              onPressed: () {
                setState(() {
                  isDestinationPage = false;
                });
              },
              child: Text(
                "back".tr(),
              ),
            ),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),

        SizedBox(
          height: height * 0.025,
        ),

        // ======================================================
        // FACEBOOK OPTION
        // ======================================================

        InkWell(
          borderRadius: BorderRadius.circular(
            width * 0.035,
          ),
          onTap: () {
            setState(() {
              isDestinationPage = false;
            });
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(
              width * 0.04,
            ),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0D1E45)
                  : const Color(0xFFF5F8FF),
              borderRadius: BorderRadius.circular(
                width * 0.035,
              ),
              border: Border.all(
                color: const Color(0xFF1877F2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: width * 0.12,
                  height: width * 0.12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1877F2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.facebook,
                    color: Colors.white,
                    size: width * 0.075,
                  ),
                ),

                SizedBox(
                  width: width * 0.035,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Facebook",
                        style: TextStyle(
                          color: textColor,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(
                        height: height * 0.004,
                      ),

                      Text(
                        "Stream using RTMP",
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: width * 0.033,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Color(0xFF1877F2),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RADIO OPTION
  // ============================================================

  Widget _radioOption(
      String value,
      Color textColor,
      double width,
      ) {
    final isSelected =
        selectedSource == value;

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
              border: Border.all(
                color: const Color(0xFF1D6EFF),
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: width * 0.022,
                height: width * 0.022,
                decoration:
                const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF1D6EFF),
                ),
              ),
            )
                : null,
          ),

          SizedBox(
            width: width * 0.02,
          ),

          Text(
            value,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}