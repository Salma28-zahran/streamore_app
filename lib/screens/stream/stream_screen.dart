import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/comment_provider.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/brand_widgets/background/background.dart';
import 'package:streamore_app/widgets/banners/show_banners.dart';
import 'package:streamore_app/widgets/permissions/camera/camera-permission.dart';
import 'package:streamore_app/widgets/brand_widgets/logo/logo.dart';
import 'package:streamore_app/widgets/permissions/mic/mic-permission.dart';
import 'package:streamore_app/widgets/overlay.dart';
import 'package:streamore_app/widgets/stream/control_buttons_row.dart';
import 'package:streamore_app/widgets/stream/custom_tab_section.dart';
import '../../provider/my_provider.dart';

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

    final commentProvider = Provider.of<CommentProvider>(context);


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
                    ProfileImageWithBanners(
                      isZoomVisible: isZoomVisible,
                      profileImageWidth: profileImageWidth,
                      profileImageHeight: profileImageHeight,
                      onZoomIconClick: _onZoomIconClick,
                      onProfileImageClick: _onProfileImageClick,
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
                toggleCam: () => requestCameraPermission(context, _toggleCamera),
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

  void _toggleCamera() {
    setState(() {
      _camOn = !_camOn;
    });
  }
}