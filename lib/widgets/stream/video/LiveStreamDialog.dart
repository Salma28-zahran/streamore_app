import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show read;
import 'package:streamore_app/core/apis/start/start_stream_cubit.dart';
import 'package:streamore_app/core/apis/start/start_stream_model.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class LiveStreamDialog extends StatefulWidget {
  const LiveStreamDialog({super.key});

  @override
  State<LiveStreamDialog> createState() => _LiveStreamDialogState();
}

class _LiveStreamDialogState extends State<LiveStreamDialog> {
  String selectedSource = "live".tr();
  bool isDestinationPage = false;

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
          color: isDark ? const Color(0xFF071332) : Colors.white,
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
              onTap: () => Navigator.pop(context),
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

        Text(
          "source".tr(),
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: width * 0.038,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(
          height: height * 0.018,
        ),

        /// Radio Buttons
        Wrap(
          spacing: width * 0.045,
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

        /// Buttons
        Column(
          children: [
            Center(
              child: SizedBox(
                width: width * 0.50,
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
                  onPressed: () {
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
              height: height * 0.012,
            ),
            Center(
              child: SizedBox(
                width: width * 0.50,
                height: height * 0.055,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D6EFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        width * 0.03,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    /// 1. start stream api
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.008,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "skip_for_now".tr(),
                style: TextStyle(
                  color: const Color(0xFF8EB5E4),
                  fontSize: width * 0.035,
                ),
              ),
            ),
          ],
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
              child: Text(
                "back".tr(),
                style: TextStyle(
                  color: const Color(0xFF8EB5E4),
                  fontSize: width * 0.045,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: width * 0.03,
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
        SizedBox(
          height: height * 0.03,
        ),
        Wrap(
          spacing: width * 0.05,
          runSpacing: height * 0.02,
          children: [
            _socialButton(
              imagePath: 'assets/images/facebook.png',
              width: width,
            ),
            _socialButton(
              imagePath: 'assets/images/linkdin.png',
              width: width,
            ),
            _socialButton(
              imagePath: 'assets/images/youtube.png',
              width: width,
            ),
            _socialButton(
              imagePath: 'assets/images/x.png',
              width: width,
            ),
            _socialButton(
              imagePath: 'assets/images/insta.png',
              width: width,
            ),
            _socialButton(
              imagePath: 'assets/images/yahoo.png',
              width: width,
            ),
          ],
        ),
        SizedBox(
          height: height * 0.03,
        ),
        Container(
          width: width * 0.38,
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
            vertical: height * 0.018,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? Colors.white : Colors.black,
            ),
            borderRadius: BorderRadius.circular(
              width * 0.03,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.dns_outlined,
                color: textColor,
              ),
              SizedBox(
                width: width * 0.01,
              ),
              Text(
                "Custom RTMP",
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: width * 0.033,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: height * 0.03,
        ),
        Text(
          "custom_rtmp_note".tr(),
          style: TextStyle(
            color: textColor,
            fontSize: width * 0.04,
          ),
        ),
      ],
    );
  }

  Widget _socialButton({
    required String imagePath,
    required double width,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: width * 0.12,
        height: width * 0.12,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _radioOption(
    String value,
    Color textColor,
    double width,
  ) {
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
              border: Border.all(
                color: const Color(0xFF1D6EFF),
                width: 1.5,
              ),
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
          SizedBox(
            width: width * 0.02,
          ),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: width * 0.038,
            ),
          ),
        ],
      ),
    );
  }
}
