import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/stream/icons/settings/lay.dart';
import 'package:streamore_app/utils/bottom_sheet_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/gestures.dart';
import 'package:streamore_app/widgets/permissions/mic/volume_test.dart';
import 'package:streamore_app/widgets/stream/circle_and_action_icons.dart';

class ControlButtonsRow extends StatefulWidget {
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
  State<ControlButtonsRow> createState() => _ControlButtonsRowState();
}

class _ControlButtonsRowState extends State<ControlButtonsRow> {
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

    return Padding(
      padding: EdgeInsets.only(
        left: size.width * 0.08,
        top: 10,
        right: size.width * 0.04,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 🎤 MIC with dropdown
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.toggleMic,
                    child: Icon(
                      widget.micOn ? Icons.mic_rounded : Icons.mic_off_rounded,
                      size: smallIconSize,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(width: 2),
        GestureDetector(
          onTapDown: (TapDownDetails details) async {
            final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;

            await showMenu(
              context: context,
              position: RelativeRect.fromRect(
                details.globalPosition & const Size(40, 40),
                Offset.zero & overlay.size,
              ),
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              items: [
                PopupMenuItem(
                  enabled: false,
                  padding: EdgeInsets.zero,
                  child: StatefulBuilder(
                    builder: (context, setInnerState) => Container(
                      width: MediaQuery.of(context).size.width * 0.72,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 55,
                            child: VolumeTest(),
                          ),
                          const SizedBox(height: 2),
                          Divider(
                            height: 6,
                            color: Colors.grey.withOpacity(0.35),
                            thickness: 0.5,
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "echo_cancellation".tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: iconColor,
                                ),
                              ),
                              Transform.scale(
                                scaleX: 0.45,
                                scaleY: 0.45,
                                child: Switch(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: _isEchoCancellation,
                                  onChanged: (value) {
                                    setInnerState(() => _isEchoCancellation = value);
                                    setState(() => _isEchoCancellation = value);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "noise_suppression".tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: iconColor,
                                ),
                              ),
                              Transform.scale(
                                scaleX: 0.45,
                                scaleY: 0.45,
                                child: Switch(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: _isNoiseSuppression,
                                  onChanged: (value) {
                                    setInnerState(() => _isNoiseSuppression = value);
                                    setState(() => _isNoiseSuppression = value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: Icon(
            Icons.arrow_drop_down,
            size: smallIconSize * 0.8,
            color: iconColor,
          ),
        )

        ],
              ),
            ),


            // 📷 CAMERA with dropdown
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.03),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.toggleCam,
                    child: Icon(
                      widget.camOn ? Icons.camera_alt_rounded : Icons.videocam_off,
                      size: smallIconSize,
                      color: iconColor,
                    ),
                  ),
                  //const SizedBox(width: 2),
              GestureDetector(
                onTapDown: (TapDownDetails details) async {
                  final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

                  await showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    items: [
                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.only(left: 4),
                        height: 30,
                        child: StatefulBuilder(
                          builder: (context, setInnerState) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "flip_camera".tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: iconColor,
                                ),
                              ),
                              Transform.scale(
                                scaleX: 28 / 59,
                                scaleY: 13 / 34,
                                child: Switch(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: _isOverlayEnabled,
                                  onChanged: (value) {
                                    setInnerState(() => _isOverlayEnabled = value);
                                    setState(() => _isOverlayEnabled = value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.only(left: 4),
                        height: 30,

                        child: StatefulBuilder(
                          builder: (context, setInnerState) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "mirror_camera".tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: iconColor,
                                ),
                              ),
                              Transform.scale(
                                scaleX: 28 / 59,
                                scaleY: 13 / 34,
                                child: Switch(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: _isOverlayEnabled2,
                                  onChanged: (value) {
                                    setInnerState(() => _isOverlayEnabled2 = value);
                                    setState(() => _isOverlayEnabled2 = value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: smallIconSize * 0.8,
                    color: iconColor,
                  ),
                ),
              )

              ],
              ),
            ),

            // 📡 CAST
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const BottomSheetWidget(),
                  );
                },
                child: Icon(Icons.cast_sharp, size: smallIconSize, color: iconColor),
              ),
            ),

            // 🪪 PROFILE
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: GestureDetector(
                onTapDown: (TapDownDetails details) async {
                  final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;

                  await showMenu(
                    context: context,
                    position: RelativeRect.fromRect(
                      details.globalPosition & const Size(40, 40),
                      Offset.zero & overlay.size,
                    ),
                    color: Theme.of(context).cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    items: [
                      PopupMenuItem(
                        enabled: false,
                        padding: EdgeInsets.zero,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            radius: const Radius.circular(12),
                            child: ListView.separated(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              itemCount: layouts.length,
                              separatorBuilder: (_, __) => Divider(
                                color: Colors.grey.withOpacity(0.4),
                                height: 12,
                              ),
                              itemBuilder: (context, index) {
                                final layout = layouts[index];
                                final isSelected = index == selectedIndex;
                                final imagePath =
                                    'assets/images/${getImageName(layout.titleKey, isSelected)}';

                                return GestureDetector(
                                  onTap: () {
                                    setState(() => selectedIndex = index);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.15)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: isSelected
                                          ? Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 1.8,
                                      )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          imagePath,
                                          height: 60,
                                          width: 60,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            layout.titleKey.tr(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isSelected
                                                  ? Theme.of(context).primaryColor
                                                  : Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .color,
                                            ),
                                          ),
                                        ),
                                        if (isSelected)
                                          const Icon(Icons.check_circle,
                                              color: Colors.green, size: 20),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.person_pin_sharp,
                    size: smallIconSize,
                    color: iconColor,
                  ),
                ),
              ),
            ),


            // ➕ ADD PERSON
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.05),
              child: GestureDetector(
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
                                    ..onTap = () {},
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
                            padding:
                            const EdgeInsets.symmetric(horizontal: 12),
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
                              onPressed: () {},
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                minimumSize: const Size(0, 36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Icon(Icons.person_add,
                      size: smallIconSize, color: iconColor),
                ),
              ),
            ),

            // ⚙️ SETTINGS
            Padding(
              padding: const EdgeInsets.only(right: 10,left: 5),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/settings_icon"),
                child: Icon(Icons.settings_outlined,
                    size: smallIconSize, color: iconColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
