import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/screens/tabs/banners_tab.dart';
import 'package:streamore_app/screens/tabs/brand_tab.dart';
import 'package:streamore_app/screens/tabs/comments_tab.dart';
import 'package:streamore_app/utils/bottom_sheet_widget.dart';
import 'package:streamore_app/widgets/overlay_style.dart';
import '../../my_provider.dart';

class StreamScreen extends StatefulWidget {
  static const String routeName = "/stream";

  const StreamScreen({super.key});

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  bool _micOn = true;
  bool _camOn = true;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmall = size.width < 360;
    final double iconSize = isSmall ? 44.0 : 50.0;
    final myprovider = Provider.of<MyProvider>(context);
    final double profileImageWidth = size.width * 0.9425;
    final double profileImageHeight = size.height * 0.28;
    final bool isDark = myprovider.themeMode == ThemeMode.dark;

    final bool hasNotification = false;

    return Scaffold(
      drawer:  MainDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).primaryColorDark,
                  size: 24,
                ),
                if (hasNotification)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.asset(
                        "assets/images/profile4.png",
                        width: profileImageWidth,
                        height: profileImageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: buildOverlay(myprovider),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Padding(
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
                    onTap: () => setState(() => _micOn = !_micOn),
                    child: _circleIcon(
                      isOn: _micOn,
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
                    onTap: () => setState(() => _camOn = !_camOn),
                    child: _circleIcon(
                      isOn: _camOn,
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
                    child: icon == Icons.cast_sharp
                        ? GestureDetector(
                            onTap: () {
                              // Show the Bottom Sheet when cast_sharp icon is tapped
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return const BottomSheetWidget();
                                },
                              );
                            },
                            child: _buildIcon(
                              Icons.cast_sharp,
                              iconSize,
                              context,
                              myprovider,
                              isSmall,
                            ),
                          )
                        : _buildIcon(
                            icon, iconSize, context, myprovider, isSmall),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: _buildIcon(
                      Icons.settings, iconSize, context, myprovider, isSmall),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.015),
              child: Container(
                width: profileImageWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(color: Theme.of(context).dividerColor),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        labelStyle: GoogleFonts.inter(
                          fontSize: isSmall ? 10 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.inter(
                          fontSize: isSmall ? 10 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: [
                          Tab(text: "brand".tr()),
                          Tab(text: "banners".tr()),
                          Tab(text: "comments".tr()),
                        ],
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            BrandTab(),
                            BannersTab(),
                            CommentsTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon({
    required bool isOn,
    required IconData onIcon,
    required IconData offIcon,
    required double size,
    required bool isSmall,
    required ThemeMode currentMode,
  }) {
    return Container(
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
        color: isOn ? Theme.of(context).iconTheme.color : Colors.red[400],
        size: isSmall ? 20 : 24,
      ),
    );
  }

  Widget _buildIcon(
    IconData icon,
    double size,
    BuildContext context,
    MyProvider myprovider,
    bool isSmall,
  ) {
    return GestureDetector(
      onTap: icon == Icons.settings
          ? () => Navigator.pushNamed(context, "/settings_icon")
          : null,
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
    );
  }
}
