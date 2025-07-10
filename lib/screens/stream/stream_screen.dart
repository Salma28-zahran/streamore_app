import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:streamore_app/screens/tabs/banners_contant.dart';
import 'package:streamore_app/screens/tabs/tickers_contant.dart';

import '../../my_provider.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/screens/tabs/banners_tab.dart';
import 'package:streamore_app/screens/tabs/brand_tab.dart';
import 'package:streamore_app/screens/tabs/comments_tab.dart';
import 'package:streamore_app/widgets/overlay_style.dart';
import 'package:streamore_app/utils/bottom_sheet_widget.dart';

class StreamScreen extends StatefulWidget {
  static const String routeName = "/stream";

  const StreamScreen({super.key});

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  bool _micOn = true;
  bool _camOn = true;
  bool _showZoomIcon = false;
  bool _isFullScreen = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmall = size.width < 360;
    final double iconSize = isSmall ? 44.0 : 50.0;
    final myprovider = Provider.of<MyProvider>(context);
    bool isFolderClicked = myprovider.bFolderClicked; 
     final double profileImageWidth = size.width * 0.9425;
    final double profileImageHeight = size.height * 0.28;

    return Scaffold(
      drawer: MainDrawer(),
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
            child: Icon(
              FontAwesomeIcons.bell,
              color: Theme.of(context).primaryColorDark,
              size: 24,
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
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showZoomIcon = true;
                      });
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: profileImageWidth,
                          height: profileImageHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              image: AssetImage("assets/images/profile4.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (_showZoomIcon)
                          Container(
                            width: profileImageWidth,
                            height: profileImageHeight,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        if (_showZoomIcon)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isFullScreen = true;
                                _showZoomIcon = false;
                              });
                            },
                            child: Image.asset(
                              'assets/images/zoom.png',
                              width: 60,
                              height: 60,
                            ),
                          ),
                      ],
                    ),
                  ),
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
                    _buildControlButton(
                      iconOn: Icons.mic,
                      iconOff: Icons.mic_off,
                      isOn: _micOn,
                      onTap: _requestMicPermission,
                      size: iconSize,
                      isSmall: isSmall,
                      themeMode: myprovider.themeMode,
                    ),
                    _buildControlButton(
                      iconOn: Icons.camera_alt_rounded,
                      iconOff: Icons.videocam_off,
                      isOn: _camOn,
                      onTap: () => setState(() => _camOn = !_camOn),
                      size: iconSize,
                      isSmall: isSmall,
                      themeMode: myprovider.themeMode,
                    ),
                    _buildIconButton(
                      icon: Icons.cast_sharp,
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const BottomSheetWidget(),
                        );
                      },
                      size: iconSize,
                      themeMode: myprovider.themeMode,
                      isSmall: isSmall,
                    ),
                    _buildIconButton(
                      icon: Icons.person_add,
                      onTap: () {},
                      size: iconSize,
                      themeMode: myprovider.themeMode,
                      isSmall: isSmall,
                    ),
                    _buildIconButton(
                      icon: Icons.settings,
                      onTap: () => Navigator.pushNamed(context, "/settings_icon"),
                      size: iconSize,
                      themeMode: myprovider.themeMode,
                      isSmall: isSmall,
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
                            tabs: [
                              Tab(text: "brand".tr()),
                              Tab(text: "banners".tr()),
                              Tab(text: "comments".tr()),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
  children: [
    const BrandTab(),
    myprovider.tFolderClicked
        ? const TickersContant()
        : myprovider.bFolderClicked
            ? const BannersContant()
            : const BannersTab(),
    const CommentsTab(),
  ],
)
,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Fullscreen profile view
          if (_isFullScreen)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isFullScreen = false;
                });
              },
              child: Container(
                color: Colors.black,
                width: double.infinity,
                height: double.infinity,
                child: Image.asset(
                  "assets/images/profile4.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData iconOn,
    required IconData iconOff,
    required bool isOn,
    required VoidCallback onTap,
    required double size,
    required bool isSmall,
    required ThemeMode themeMode,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size),
            color: isOn
                ? (themeMode == ThemeMode.dark
                    ? const Color(0xff212b49)
                    : const Color(0xff5E5E66))
                : const Color(0xff350808),
          ),
          child: Icon(
            isOn ? iconOn : iconOff,
            color: isOn ? Colors.white : Colors.red[400],
            size: isSmall ? 20 : 24,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
    required ThemeMode themeMode,
    required bool isSmall,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            color: themeMode == ThemeMode.dark
                ? const Color(0xff212b49)
                : const Color(0xff5E5E66),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: isSmall ? 20 : 24,
          ),
        ),
      ),
    );
  }

  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() {
        _micOn = !_micOn;
      });
    } else if (status.isDenied) {
      _showPermissionDeniedDialog();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Permission Denied"),
        content: const Text("You need to grant microphone access to use this feature."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
