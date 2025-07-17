import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
import 'package:streamore_app/widgets/background.dart';
import 'package:streamore_app/widgets/logo.dart';
import 'package:streamore_app/widgets/mic-permission.dart';
import 'package:streamore_app/widgets/overlay.dart';
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
  late TabController _tabController;
  bool isZoomVisible = false;

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
    final myProvider = Provider.of<MyProvider>(context);

    final double profileImageWidth = size.width * 0.9425;
    final double profileImageHeight = size.height * 0.28;
    final bool isDark = myprovider.themeMode == ThemeMode.dark;

    final bool hasNotification = false;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _onProfileImageClick,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Image.asset(
                              "assets/images/profile4.png",
                              width: profileImageWidth,
                              height: profileImageHeight,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (isZoomVisible)
                          Positioned(
                            top: profileImageHeight / 2 - 27,
                            left: profileImageWidth / 2 - 27,
                            child: GestureDetector(
                              onTap: _onZoomIconClick,
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(
                                  'assets/images/zoom.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: _buildThemeOverlay(context, myProvider),
                        ),
                        Positioned(
                          bottom: 100,
                          left: 16,
                          right: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:
                                myProvider.comments.map((comment) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 24,
                                          color: Colors.white54,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
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
                                  );
                                }).toList(),
                          ),
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
                        onTap: () => requestMicPermission(context, _toggleMic),
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
                        child:
                            icon == Icons.person_add
                                ? GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            backgroundColor:
                                                Theme.of(context).cardColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            title: Text(
                                              "add_members".tr(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color:
                                                    isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    text:
                                                        'you_can_add_up_to_guests'
                                                            .tr(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 13,
                                                      color: Colors.grey[700],
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            'upgrade_for_more'
                                                                .tr(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                // action here
                                                              },
                                                      ),
                                                    ],
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 16),
                                                Container(
                                                  width: double.infinity,
                                                  height: 26,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                      ),
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Colors.grey,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).cardColor,
                                                  ),
                                                  child: Text(
                                                    "https://www.examplecode.com/xyz-pwd-srt",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color:
                                                          isDark
                                                              ? Colors.white
                                                              : Colors.black,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),
                                                // Copy Button
                                                SizedBox(
                                                  width: 110,
                                                  height: 28,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      // copy link logic
                                                    },
                                                    icon: const Icon(
                                                      Icons.copy,
                                                      size: 18,
                                                    ),
                                                    label: Text(
                                                      "copy_link".tr(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                            fontSize: 11,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                            0xff1865E8,
                                                          ),
                                                      foregroundColor:
                                                          Colors.white,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                          ),
                                                      minimumSize: const Size(
                                                        0,
                                                        36,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                  24,
                                                  20,
                                                  24,
                                                  10,
                                                ),
                                            actionsPadding:
                                                const EdgeInsets.only(
                                                  bottom: 10,
                                                  right: 0,
                                                ),
                                          ),
                                    );
                                  },
                                  child: _buildIcon(
                                    icon,
                                    iconSize,
                                    context,
                                    myprovider,
                                    isSmall,
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
                                  child: _buildIcon(
                                    icon,
                                    iconSize,
                                    context,
                                    myprovider,
                                    isSmall,
                                  ),
                                ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(right: 13),
                      child: _buildIcon(
                        Icons.settings,
                        iconSize,
                        context,
                        myprovider,
                        isSmall,
                      ),
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
                      length: 4,
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
                          Expanded(
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                BrandTab(),
                                myprovider.tFolderClicked
                                    ? const TickersContant()
                                    : myprovider.bFolderClicked
                                    ? const BannersContant()
                                    : const BannersTab(),
                                const CommentsTab(),
                                ChatTab(),
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
          BackgroundWidget(),
          OverlayWidget(),
          LogoWidget(),
        ],
      ),
    );
  }

  void _onProfileImageClick() {
    setState(() {
      isZoomVisible = !isZoomVisible;
    });
  }

  void _onZoomIconClick() {
    Navigator.pushNamed(context, '/full_image');
  }

  void _toggleMic() {
    setState(() {
      _micOn = !_micOn;
    });
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
        color:
            isOn
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
      onTap:
          icon == Icons.settings
              ? () => Navigator.pushNamed(context, "/settings_icon")
              : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(190),
          color:
              myprovider.themeMode == ThemeMode.dark
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
            style: getFontStyle(
              context,
              font,
              fontSize: 12,
              color: Colors.white,
            ),
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
                    style: getFontStyle(
                      context,
                      font,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
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
            style: getFontStyle(
              context,
              font,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      );
  }
}
