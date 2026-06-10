import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/background-overlay-logo_provider.dart';
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/brand_widgets/background/background.dart';
import 'package:streamore_app/widgets/brand_widgets/background/overlay.dart';
import 'package:streamore_app/widgets/brand_widgets/logo/logo.dart';
import 'package:streamore_app/widgets/permissions/camera/camera-permission.dart';
import 'package:streamore_app/widgets/permissions/mic/mic-permission.dart';
import 'package:streamore_app/widgets/stream/ExpandToolsWidget.dart';
import 'package:streamore_app/widgets/stream/comment_overlay_widget.dart';
import 'package:streamore_app/widgets/stream/control_buttons_row.dart';
import '../../../../widgets/stream/video/show_banners.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool _micOn = true;
bool _camOn = true;
bool isZoomVisible = false;
int? userId;

class _HomeScreenState extends State<HomeScreen> {
  String currentLayout = 'default';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmall = size.width < 360;
    final double iconSize = isSmall ? 44.0 : 50.0;

    final myprovider = Provider.of<MyProvider>(context);
    Provider.of<CommentProvider>(context);


    final myProvider = Provider.of<MyProvider>(context);
    final double profileImageWidth =
    myProvider.orientation == "landscape"
        ? size.width * 0.9425
        : size.width * 0.9425;

    final double profileImageHeight =
    myProvider.orientation == "landscape"
        ? size.height * 0.28
        : size.height * 0.44;

    return Consumer<BackgroundOverlayLogoProvider>(
      builder: (context, provider, child) {
        final hasBackgroundImage = provider.selectedBackgroundImage != null &&
            provider.isBackgroundVisible;

        return Scaffold(
          backgroundColor: hasBackgroundImage
              ? Colors.transparent
              : Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xff222222)
                  : Colors.white,
          drawer: MainDrawer(),
          appBar: const CustomAppBar(
            hasNotification: false,
          ),
          body: Stack(
            children: [
              if (hasBackgroundImage)
                Positioned.fill(
                  child: Image.file(
                    File(provider.selectedBackgroundImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 130,
                      left: 8,
                      right: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            ProfileImageWithBanners(
                              isZoomVisible: isZoomVisible,
                              profileImageWidth: profileImageWidth,
                              profileImageHeight: profileImageHeight,
                              onZoomIconClick: _onZoomIconClick,
                              onProfileImageClick: _onProfileImageClick,
                              layout: currentLayout,
                            ),
                            LogoWidget(),

                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: ControlButtonsRow(
                        currentLayout: currentLayout,
                        onLayoutChanged: (layout) {
                          setState(() {
                            currentLayout = layout;
                          });
                        },
                        micOn: _micOn,
                        camOn: _camOn,
                        iconSize: iconSize,
                        isSmall: isSmall,
                        toggleMic: () =>
                            requestMicPermission(context, _toggleMic),
                        toggleCam: () =>
                            requestCameraPermission(context, _toggleCamera),
                      ),
                    ),
                  ),
                ],
              ),

              /// ExpandTools فوق كل حاجة
              Positioned(
                left: 0,
                right: 0,
                bottom: 110,
                child: const ExpandToolsWidget(),
              ),

             // BackgroundWidget(),


              if (myProvider.isOverlayEnabled) CommentOverlayWidget(),
            ],
          ),
        );
      },
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
