import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:streamore_app/screens/tabs/banners_contant.dart';
import 'package:streamore_app/screens/tabs/tickers_contant.dart';
import 'package:streamore_app/screens/tabs/banners_tab.dart';
import 'package:streamore_app/screens/tabs/brand_tab.dart';
import 'package:streamore_app/screens/tabs/comments_tab.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/utils/bottom_sheet_widget.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/brand_widgets/brand_utils/font_utils.dart';
import 'package:streamore_app/widgets/overlay_style.dart';

import '../../my_provider.dart';

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
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmall = size.width < 360;
    final double iconSize = isSmall ? 44.0 : 50.0;

    final myProvider = Provider.of<MyProvider>(context);
    final double profileImageWidth = size.width * 0.9425;
    final double profileImageHeight = size.height * 0.28;

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: const CustomAppBar(hasNotification: false),
      body: Stack(
        children: [
          _buildVideoAndComments(profileImageWidth, profileImageHeight),
          _buildControlPanel(size, iconSize, isSmall),
          _buildTabsContainer(profileImageWidth),
          _buildDynamicBackground(),
          _buildDynamicOverlay(),
          _buildDynamicLogo(),
          if (_isFullScreen) _buildFullScreenPreview(),
        ],
      ),
    );
  }

  /// *************************  Top video area with theme & comments  *************************
  Widget _buildVideoAndComments(double width, double height) {
    final provider = Provider.of<MyProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
      child: Center(
        child: GestureDetector(
          onTap: () => setState(() => _showZoomIcon = true),
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Image.asset(
                  "assets/images/profile4.png",
                  width: width,
                  height: height,
                  fit: BoxFit.cover,
                ),
              ),
              if (_showZoomIcon)
                Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              if (_showZoomIcon)
                GestureDetector(
                  onTap: () => setState(() {
                    _isFullScreen = true;
                    _showZoomIcon = false;
                  }),
                  child: Image.asset(
                    'assets/images/zoom.png',
                    width: 60,
                    height: 60,
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                child: _buildThemeOverlay(provider),
              ),
              // ------------------ comments overlay ------------------
              Positioned(
                bottom: 100,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: provider.comments.map((comment) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.person, size: 24, color: Colors.white54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "UserName",
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment,
                                  style: const TextStyle(color: Colors.white, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// *************************  Bottom control buttons  *************************
  Widget _buildControlPanel(Size size, double iconSize, bool isSmall) {
    final myProvider = Provider.of<MyProvider>(context);

    return Positioned(
      top: size.height * 0.30,
      left: size.width * 0.08,
      right: size.width * 0.04,
      child: Row(
        children: [
          _buildControlButton(
            iconOn: Icons.mic,
            iconOff: Icons.mic_off,
            isOn: _micOn,
            onTap: _requestMicPermission,
            size: iconSize,
            isSmall: isSmall,
            themeMode: myProvider.themeMode,
          ),
          _buildControlButton(
            iconOn: Icons.camera_alt_rounded,
            iconOff: Icons.videocam_off,
            isOn: _camOn,
            onTap: () => setState(() => _camOn = !_camOn),
            size: iconSize,
            isSmall: isSmall,
            themeMode: myProvider.themeMode,
          ),
          _buildIconButton(
            icon: Icons.cast_sharp,
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const BottomSheetWidget(),
            ),
            size: iconSize,
            themeMode: myProvider.themeMode,
            isSmall: isSmall,
          ),
          _buildIconButton(
            icon: Icons.person_add,
            onTap: _showAddMembersDialog,
            size: iconSize,
            themeMode: myProvider.themeMode,
            isSmall: isSmall,
          ),
          _buildIconButton(
            icon: Icons.settings,
            onTap: () => Navigator.pushNamed(context, "/settings_icon"),
            size: iconSize,
            themeMode: myProvider.themeMode,
            isSmall: isSmall,
          ),
        ],
      ),
    );
  }

  /// *************************  Tabs container  *************************
  Widget _buildTabsContainer(double profileImageWidth) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;

    return Positioned(
      top: size.height * 0.42,
      left: (size.width - profileImageWidth) / 2,
      right: (size.width - profileImageWidth) / 2,
      bottom: size.height * 0.02,
      child: Container(
        width: profileImageWidth,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.9), blurRadius: 3, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              labelStyle: GoogleFonts.inter(fontSize: isSmall ? 10 : 12, fontWeight: FontWeight.w600),
              tabs: [Tab(text: "brand".tr()), Tab(text: "banners".tr()), Tab(text: "comments".tr())],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const BrandTab(),
                  Consumer<MyProvider>(builder: (context, provider, _) {
                    if (provider.tFolderClicked) return const TickersContant();
                    if (provider.bFolderClicked) return const BannersContant();
                    return const BannersTab();
                  }),
                  const CommentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// *************************  Dynamic background from provider  *************************
  Widget _buildDynamicBackground() {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        if (!provider.isBackgroundVisible || provider.selectedBackgroundImage == null) return const SizedBox();

        final size = MediaQuery.of(context).size;
        final double width = size.width * 0.9425;
        final double height = size.height * 0.28;

        return Positioned(
          top: 0,
          left: (size.width - width) / 2,
          right: (size.width - width) / 2,
          child: GestureDetector(
            onTap: provider.toggleBackgroundVisibility,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                image: DecorationImage(
                  image: FileImage(File(provider.selectedBackgroundImage!.path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// *************************  Dynamic overlay from provider  *************************
  Widget _buildDynamicOverlay() {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        if (!provider.isOverlayVisible) return const SizedBox();

        final size = MediaQuery.of(context).size;
        final double frameWidth = size.width * 0.7;
        final double frameHeight = size.height * 0.25;
        final double frameTop = size.height * 0.03;
        final double horizontalPadding = (size.width - frameWidth) / 2;

        return Positioned(
          top: frameTop,
          left: horizontalPadding,
          right: horizontalPadding,
          child: GestureDetector(
            onTap: provider.toggleOverlayVisibility,
            child: Container(
              width: frameWidth,
              height: frameHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: const Offset(0, 2))],
                image: DecorationImage(
                  image: provider.selectedOverlayImage != null
                      ? FileImage(File(provider.selectedOverlayImage!.path))
                      : const AssetImage('assets/images/overlay_placeholder.png') as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// *************************  Dynamic logo from provider  *************************
  Widget _buildDynamicLogo() {
    return Consumer<MyProvider>(
      builder: (context, provider, _) {
        if (!provider.isLogoVisible) return const SizedBox();
        return Positioned(
          top: 20,
          right: 40,
          child: GestureDetector(
            onTap: provider.toggleLogoVisibility,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: const Offset(0, 2))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: provider.logoImageFile != null
                    ? Image.file(File(provider.logoImageFile!.path), width: 50, height: 50, fit: BoxFit.cover)
                    : Image.asset('assets/images/logo.png', width: 50, height: 50, fit: BoxFit.cover),
              ),
            ),
          ),
        );
      },
    );
  }

  /// *************************  Full screen preview  *************************
  Widget _buildFullScreenPreview() {
    return GestureDetector(
      onTap: () => setState(() => _isFullScreen = false),
      child: Container(
        color: Colors.black,
        width: double.infinity,
        height: double.infinity,
        child: Image.asset("assets/images/profile4.png", fit: BoxFit.cover),
      ),
    );
  }

  /// *************************  Reusable buttons  *************************
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
                ? (themeMode == ThemeMode.dark ? const Color(0xff212b49) : const Color(0xff5E5E66))
                : const Color(0xff350808),
          ),
          child: Icon(isOn ? iconOn : iconOff, color: isOn ? Colors.white : Colors.red[400], size: isSmall ? 20 : 24),
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
            color: themeMode == ThemeMode.dark ? const Color(0xff212b49) : const Color(0xff5E5E66),
          ),
          child: Icon(icon, color: Colors.white, size: isSmall ? 20 : 24),
        ),
      ),
    );
  }

  /// *************************  Dialogs & permissions  *************************
  Future<void> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() => _micOn = !_micOn);
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
        actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("OK"))],
      ),
    );
  }

  void _showAddMembersDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text("add_members".tr(), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18, color: isDark ? Colors.white : Colors.black)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'you_can_add_up_to_guests'.tr(),
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700]),
                children: [
                  TextSpan(
                    text: 'upgrade_for_more'.tr(),
                    style: GoogleFonts.poppins(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      // upgrade action
                    },
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            // meeting link
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
              child: Text("https://www.examplecode.com/xyz-pwd-srt", style: GoogleFonts.poppins(fontSize: 12, color: isDark ? Colors.white : Colors.black), overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(height: 16),
            // copy button
            SizedBox(
              width: 110,
              height: 28,
              child: ElevatedButton.icon(
                onPressed: () {
                  // copy link logic
                },
                icon: const Icon(Icons.copy, size: 18),
                label: Text("copy_link".tr(), style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1865E8),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  minimumSize: const Size(0, 36),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
              ),
            ),
          ],
        ),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
        actionsPadding: const EdgeInsets.only(bottom: 10, right: 0),
      ),
    );
  }
}

/// *************************  Theme overlay builder  *************************
Widget _buildThemeOverlay(MyProvider provider) {
  final theme = provider.selectedTheme;
  final color = provider.primaryColor;
  final font = provider.selectedFont;

  switch (theme) {
    case 'bubble':
      return Padding(
        padding: const EdgeInsets.all(11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(100)),
          child: Text("user_name".tr(), style: getFontStyle(font, fontSize: 12, color: Colors.white)),
        ),
      );

    case 'minimal':
      return Padding(
        padding: const EdgeInsets.only(bottom: 11),
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
                    style: getFontStyle(font, fontSize: 12, color: Colors.black87),
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
        padding: const EdgeInsets.all(11),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(0)),
          child: Text("user_name".tr(), style: getFontStyle(font, fontSize: 12, color: Colors.white)),
        ),
      );
  }
}
