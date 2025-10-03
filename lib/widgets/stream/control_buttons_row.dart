import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/stream/stream_screen.dart';
import 'package:streamore_app/utils/bottom_sheet_widget.dart';
//import 'package:streamore_app/widgets/bottom_sheet_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:streamore_app/widgets/stream/circle_and_action_icons.dart';


class ControlButtonsRow extends StatelessWidget {
  final bool micOn;
  final bool camOn;
  final double iconSize;
  final bool isSmall;
  final VoidCallback toggleMic;
  final VoidCallback toggleCam;

  const ControlButtonsRow({
    super.key,
    required this.micOn,
    required this.camOn,
    required this.iconSize,
    required this.isSmall,
    required this.toggleMic,
    required this.toggleCam,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myprovider = Provider.of<MyProvider>(context);
    final isDark = myprovider.themeMode == ThemeMode.dark;

    return Padding(
      padding: EdgeInsets.only(
        left: size.width * 0.08,
        top: 8,
        right: size.width * 0.04,
      ),
      child:
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.04),
              child: GestureDetector(
                onTap: toggleMic,
                child: circleIcon(
                  context: context,
                  isOn: micOn,
                  onIcon: Icons.mic,
                  offIcon: Icons.mic_off,
                  size: iconSize,
                  isSmall: isSmall,
                  currentMode: myprovider.themeMode,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.06),
              child: GestureDetector(
                onTap: toggleCam,
                child: circleIcon(
                  context: context,
                  isOn: camOn,
                  onIcon: Icons.camera_alt_rounded,
                  offIcon: Icons.videocam_off,
                  size: iconSize,
                  isSmall: isSmall,
                  currentMode: myprovider.themeMode,
                ),
              ),
            ),
            for (var icon in [Icons.cast_sharp, Icons.person_add])
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.06),
                child: icon == Icons.person_add
                    ? GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        title: Text(
                          "add_members".tr(),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'you_can_add_up_to_guests'.tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                                children: [
                                  TextSpan(
                                    text: 'upgrade_for_more'.tr(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // upgrade action
                                      },
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              height: 26,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(6),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Text(
                                "https://www.examplecode.com/xyz-pwd-srt",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 110,
                              height: 28,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // copy link
                                },
                                icon: const Icon(Icons.copy, size: 18),
                                label: Text(
                                  "copy_link".tr(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff1865E8),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  minimumSize: const Size(0, 36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
                        actionsPadding: const EdgeInsets.only(bottom: 10, right: 0),
                      ),
                    );
                  },
                  child: buildIcon(
                    context: context,
                    icon: icon,
                    size: iconSize,
                    myprovider: myprovider,
                    isSmall: isSmall,
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => const BottomSheetWidget(),
                    );
                  },
                  child: buildIcon(
                    context: context,
                    icon: icon,
                    size: iconSize,
                    myprovider: myprovider,
                    isSmall: isSmall,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(right: 13),
              child: buildIcon(
                context: context,
                icon: Icons.settings,
                size: iconSize,
                myprovider: myprovider,
                isSmall: isSmall,
                onTap: () => Navigator.pushNamed(context, "/settings_icon"),
              ),
            ),
          ],
        ),
      )

    );
  }


}
