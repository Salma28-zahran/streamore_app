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
import 'package:streamore_app/widgets/stream/control_buttons_row.dart';
import 'package:streamore_app/widgets/stream/custom_tab_section.dart';
import 'package:streamore_app/widgets/stream/profile_image_widget.dart';
import 'package:streamore_app/widgets/stream/theme_overlay_widget.dart';
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
                    ProfileImageWidget(
                      isZoomVisible: isZoomVisible,
                      profileImageWidth: profileImageWidth,
                      profileImageHeight: profileImageHeight,
                      onZoomClick: _onZoomIconClick,
                      onProfileClick: _onProfileImageClick,
                      themeOverlay: ThemeOverlayWidget(provider: myProvider),
                      comments:
                          myProvider.comments.map((comment) {
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
                  ],
                ),
              ),

              ControlButtonsRow(
                micOn: _micOn,
                camOn: _camOn,
                iconSize: iconSize,
                isSmall: isSmall,
                toggleMic: () => requestMicPermission(context, _toggleMic),
                toggleCam: () => setState(() => _camOn = !_camOn),
              ),

              const SizedBox(height: 8),

              CustomTabSection(
                tabController: _tabController,
                profileImageWidth: profileImageWidth,
                isSmall: isSmall,
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
}
