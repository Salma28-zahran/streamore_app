import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/stream/icons/settings/lay.dart';
import 'package:streamore_app/utils/bottom_sheet_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:streamore_app/widgets/permissions/mic/volume_test.dart';
import 'package:flutter/services.dart';

class IconsStream extends StatefulWidget {
  final bool micOn;
  final bool camOn;
  final double iconSize;
  final bool isSmall;
  final VoidCallback toggleMic;
  final VoidCallback toggleCam;

  const IconsStream({
    super.key,
    required this.micOn,
    required this.camOn,
    required this.iconSize,
    required this.isSmall,
    required this.toggleMic,
    required this.toggleCam,
  });

  @override
  State<IconsStream> createState() => _IconsStreamState();
}

class _IconsStreamState extends State<IconsStream> {
  bool _isEchoCancellation = true;
  bool _isNoiseSuppression = false;
  bool _isOverlayEnabled = false;
  bool _isOverlayEnabled2 = false;
  bool _isOverlayEnabled3 = false;

  int selectedIndex = 1;

  final List<LayoutOption> layouts = [
    LayoutOption(titleKey: 'default'),
    LayoutOption(titleKey: 'cropped_layout'),
    LayoutOption(titleKey: 'spotlight_layout'),
    LayoutOption(titleKey: 'screen_layout'),
    LayoutOption(titleKey: 'picture_in_picture'),
    LayoutOption(titleKey: 'news_layout'),
    LayoutOption(titleKey: 'cinema_layout'),
  ];

  void selectLayout(int index) => setState(() => selectedIndex = index);

  String getImageName(String key, bool isSelected) {
    final prefix = key == 'default' ? 'defaultt' : key;
    return isSelected ? '${prefix}_selected.png' : '$prefix.png';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myprovider = Provider.of<MyProvider>(context);
    final isDark = myprovider.themeMode == ThemeMode.dark;
    final iconColor = isDark ? Colors.white : const Color(0xFF4A4A4A);
    final double smallIconSize = widget.iconSize * 0.7;

    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          /// 🎤 MIC
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              GestureDetector(
                onTap: widget.toggleMic,
                child: Icon(
                  widget.micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                  size: smallIconSize,
                  color: iconColor,
                ),
              ),
              GestureDetector(
                onTapDown: (details) async {
                  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                  await showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      PopupMenuItem(
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, setInner) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 50, child: VolumeTest()),
                              SwitchListTile(
                                title: Text("echo_cancellation".tr()),
                                value: _isEchoCancellation,
                                onChanged: (v) {
                                  setInner(() => _isEchoCancellation = v);
                                  setState(() => _isEchoCancellation = v);
                                },
                              ),
                              SwitchListTile(
                                title: Text("noise_suppression".tr()),
                                value: _isNoiseSuppression,
                                onChanged: (v) {
                                  setInner(() => _isNoiseSuppression = v);
                                  setState(() => _isNoiseSuppression = v);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: Icon(Icons.arrow_drop_down, color: iconColor),
              ),
            ],
          ),

          const SizedBox(width: 10),

          /// 📷 CAMERA
          Row(
            children: [
              GestureDetector(
                onTap: widget.toggleCam,
                child: Icon(
                  widget.camOn ? Icons.videocam : Icons.videocam_off,
                  size: smallIconSize,
                  color: iconColor,
                ),
              ),
              GestureDetector(
                onTapDown: (details) async {
                  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

                  await showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    items: [
                      PopupMenuItem(
                        enabled: false,
                        child: StatefulBuilder(
                          builder: (context, setInner) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SwitchListTile(
                                title: Text("flip_camera".tr()),
                                value: _isOverlayEnabled,
                                onChanged: (v) {
                                  setInner(() => _isOverlayEnabled = v);
                                  setState(() => _isOverlayEnabled = v);
                                },
                              ),
                              SwitchListTile(
                                title: Text("mirror_camera".tr()),
                                value: _isOverlayEnabled2,
                                onChanged: (v) {
                                  setInner(() => _isOverlayEnabled2 = v);
                                  setState(() => _isOverlayEnabled2 = v);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: Icon(Icons.arrow_drop_down, color: iconColor),
              ),
            ],
          ),

          const SizedBox(width: 10),

          /// 📡 CAST
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              builder: (_) => const BottomSheetWidget(),
            ),
            child: Icon(Icons.cast, color: iconColor),
          ),


          const SizedBox(width: 10),

          ///  INVITE
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/invite"),
            child: const Icon(
              Icons.login_rounded,
              color: Colors.red,
              size: 26,
            ),
          ),






          const SizedBox(width: 10),

          /// ⚙️ SETTINGS
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/settings_icon"),
            child: Icon(Icons.settings, color: iconColor),
          ),
        ],
      ),
    );
  }
}

/// ========================
/// HELPERS (بدون تغيير)
/// ========================

Widget circleIcon({
  required BuildContext context,
  required bool isOn,
  required IconData onIcon,
  required IconData offIcon,
  required double size,
  required bool isSmall,
  required ThemeMode currentMode,
  VoidCallback? onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(size),
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color: isOn
              ? (currentMode == ThemeMode.dark
              ? const Color(0xff212b49)
              : const Color(0xff5E5E66))
              : const Color(0xff350808),
        ),
        child: Icon(
          isOn ? onIcon : offIcon,
          color: isOn
              ? Theme.of(context).iconTheme.color
              : Colors.red[400],
          size: isSmall ? 20 : 24,
        ),
      ),
    ),
  );
}

Widget buildIcon({
  required BuildContext context,
  required IconData icon,
  required double size,
  required MyProvider myprovider,
  required bool isSmall,
  VoidCallback? onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(190),
      onTap: onTap ??
          (icon == Icons.settings
              ? () => Navigator.pushNamed(context, "/settings_icon")
              : null),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(190),
          color: myprovider.themeMode == ThemeMode.dark
              ? const Color(0xff212b49)
              : const Color(0xff5E5E66),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
          size: isSmall ? 20 : 24,
        ),
      ),
    ),
  );
}