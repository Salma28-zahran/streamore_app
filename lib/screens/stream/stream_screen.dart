import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/screens/tabs/banners_contant.dart';
import 'package:streamore_app/screens/tabs/banners_tab.dart';
import 'package:streamore_app/screens/tabs/brand_tab.dart';
import 'package:streamore_app/screens/tabs/chat_tab.dart';
import 'package:streamore_app/screens/tabs/comments_tab.dart';
import 'package:streamore_app/screens/tabs/tickers_contant.dart';
import 'package:streamore_app/utils/bottom_sheet_widget.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/overlay_style.dart';
import '../../my_provider.dart';
import 'package:streamore_app/widgets/brand_widgets/brand_utils/font_utils.dart';

class StreamScreen extends StatefulWidget {
  static const String routeName = "/stream";

  const StreamScreen({super.key});

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen>
    with TickerProviderStateMixin {
  bool _micOn = true;
  bool _camOn = true;
  bool _showZoomIcon = false;
  bool _isFullScreen = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmall = size.width < 360;
    final double iconSize = isSmall ? 44.0 : 50.0;
    final myprovider = Provider.of<MyProvider>(context);
    final selectedTheme = myprovider.selectedTheme;
    final font = myprovider.selectedFont;
    final primaryColor = myprovider.primaryColor;
    final XFile? logoImageFile = myprovider.logoImageFile;
    final bool isDark = myprovider.themeMode == ThemeMode.dark;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

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
                          width: size.width * 0.9425,
                          height: size.height * 0.28,
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
                            width: size.width * 0.9425,
                            height: size.height * 0.28,
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
              Positioned(
                bottom: 0,
                left: 0,
                child: _buildThemeOverlay(context, myProvider),
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
                      onTap:
                          () => Navigator.pushNamed(context, "/settings_icon"),
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
                    width: size.width * 0.9425,
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
                            controller: _tabController,
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
                              Tab(text: "chat".tr()),
                            ],
                          ),

                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [

                                const BrandTab(),
                                myprovider.tFolderClicked
                                    ? const TickersContant()
                                    : myprovider.bFolderClicked
                                    ? const BannersContant()
                                    : const BannersTab(),
                                const CommentsTab(),
                                ChatTab(),
                                Text(
                                  "UserName",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 6,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                ),

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

          // Background
          Consumer<MyProvider>(
            builder: (context, provider, child) {
              if (provider.selectedBackgroundImage == null) return SizedBox();

              double profileImageWidth =
                  MediaQuery.of(context).size.width * 0.9425;
              double profileImageHeight =
                  MediaQuery.of(context).size.height * 0.28;

              return Positioned(
                top: 0,
                left:
                    (MediaQuery.of(context).size.width - profileImageWidth) / 2,
                right:
                    (MediaQuery.of(context).size.width - profileImageWidth) / 2,
                child: GestureDetector(
                  onTap: () {
                    print("Tapped on background!");
                    print(
                      "selectedBackgroundImage: ${provider.selectedBackgroundImage?.path}",
                    );
                  },
                  child: Container(
                    width: profileImageWidth,
                    height: profileImageHeight,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      image: DecorationImage(
                        image:
                            provider.selectedBackgroundImage != null
                                ? FileImage(
                                  File(provider.selectedBackgroundImage!.path),
                                )
                                : AssetImage(
                                      'assets/images/background_placeholder.png',
                                    )
                                    as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Overlay
          Consumer<MyProvider>(
            builder: (context, provider, child) {
              if (!provider.isOverlayVisible) return SizedBox();

              double screenWidth = MediaQuery.of(context).size.width;
              double screenHeight = MediaQuery.of(context).size.height;

              double frameWidth = screenWidth * 0.7;
              double frameHeight = screenHeight * 0.25;
              double frameTop = screenHeight * 0.03;

              double horizontalPadding = (screenWidth - frameWidth) / 2;

              return Positioned(
                top: frameTop,
                left: horizontalPadding,
                right: horizontalPadding,
                child: GestureDetector(
                  onTap: () {
                    provider.toggleOverlayVisibility();
                  },
                  child: Container(
                    width: frameWidth,
                    height: frameHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      width: frameWidth,
                      height: frameHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image:
                              provider.selectedOverlayImage != null
                                  ? FileImage(
                                    File(provider.selectedOverlayImage!.path),
                                  )
                                  : AssetImage(
                                    'assets/images/overlay_placeholder.png',
                                  ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Logo
          Consumer<MyProvider>(
            builder: (context, provider, child) {
              if (!provider.isLogoVisible) return SizedBox();

              return Positioned(
                top: 20,
                right: 40,
                child: GestureDetector(
                  onTap: () {
                    provider.toggleLogoVisibility();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child:
                          provider.logoImageFile != null
                              ? Image.file(
                                File(provider.logoImageFile!.path),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                              : Image.asset(
                                'assets/images/logo.png',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                    ),
                  ),
                ),
              );
            },
          ),

          // Fullscreen Image
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
                  length: 4,
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
                          Tab(text: "chat".tr()),
                        ],
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [BrandTab(), BannersTab(), CommentsTab(),ChatTab()],
                        ),
                      ),
                    ],
                  ),
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
            color:
                isOn
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
      builder:
          (_) => AlertDialog(
            title: const Text("Permission Denied"),
            content: const Text(
              "You need to grant microphone access to use this feature.",
            ),
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

Widget _buildIconButton({
  required IconData icon,
  required VoidCallback onTap,
  required double size,
  required ThemeMode themeMode,
  required bool isSmall,
}) {
  return Padding(
    padding: EdgeInsets.only(right: isSmall ? 8 : 12),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          color:
              themeMode == ThemeMode.dark
                  ? const Color(0xff212b49)
                  : const Color(0xff5E5E66),
        ),
        child: Icon(icon, color: Colors.white, size: isSmall ? 20 : 24),
      ),
    
Widget _buildThemeOverlay(BuildContext context, MyProvider provider) {
  final theme = provider.selectedTheme;
  final color = provider.primaryColor;
  final font = provider.selectedFont;

  switch (theme) {
    case 'bubble':
      return Padding(
        padding: EdgeInsets.all(11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            "user_name".tr(),
            style: getFontStyle(context, font, fontSize: 12, color: Colors.white),
          ),
        ),
      );

    case 'minimal':
      return Padding(
        padding: EdgeInsets.only(bottom: 11),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 12, height: 24, color: color),
              Container(
                width: 76,
                height: 23,
                color: Colors.white,
                child: Center(
                  child: Text(
                    "user_name".tr(),
                    style: getFontStyle(context, font, fontSize: 12, color: Colors.black87),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

    case 'news':
    default:
      return Padding(
        padding: EdgeInsets.all(11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(0),
          ),
          child: Text(
            "user_name".tr(),
            style: getFontStyle(context, font, fontSize: 12, color: Colors.white),
          ),
        ),
      );
  }
}
