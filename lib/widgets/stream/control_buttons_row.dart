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
          for (var icon in [Icons.cast_sharp, Icons.exit_to_app])
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.06),
              child: icon == Icons.exit_to_app
                  ? buildIcon(
                context: context,
                icon: icon,
                size: iconSize,
                myprovider: myprovider,
                isSmall: isSmall,
                onTap: () {
                  Navigator.pushReplacementNamed(context, StreamScreen.routeName);
                },
              )
                  : buildIcon(
                context: context,
                icon: icon,
                size: iconSize,
                myprovider: myprovider,
                isSmall: isSmall,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const BottomSheetWidget(),
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: buildIcon(
              context: context,
              icon:Icons.settings,
              size: iconSize,
              myprovider: myprovider,
              isSmall: isSmall,
              onTap: () => Navigator.pushNamed(context, "/settings_icon"),

            ),
          ),
        ],
      ),
    );
  }


}
