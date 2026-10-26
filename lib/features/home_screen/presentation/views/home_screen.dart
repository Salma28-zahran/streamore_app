import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:streamore_app/core/provider/background-overlay-logo_provider.dart';
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';

import 'package:streamore_app/features/drawer/main_drawer.dart';

import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:streamore_app/widgets/brand_widgets/logo/logo.dart';

import 'package:streamore_app/widgets/permissions/camera/camera-permission.dart';
import 'package:streamore_app/widgets/permissions/mic/mic-permission.dart';

import 'package:streamore_app/widgets/stream/ExpandToolsWidget.dart';
import 'package:streamore_app/widgets/stream/comment_overlay_widget.dart';
import 'package:streamore_app/widgets/stream/control_buttons_row.dart';
import 'package:streamore_app/widgets/stream/video/mobile_studio_webview.dart';
import 'package:streamore_app/widgets/stream/video/show_banners.dart';


class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _micOn = true;
  bool _camOn = true;
  bool _isZoomVisible = false;

  String _currentLayout = 'default';

  @override
  Widget build(BuildContext context) {
    final Size size =
        MediaQuery.of(context).size;

    final bool isSmall =
        size.width < 360;

    final double iconSize =
    isSmall ? 44.0 : 50.0;

    final MyProvider myProvider =
    context.watch<MyProvider>();

    context.watch<CommentProvider>();

    final double profileImageWidth =
        size.width * 0.9425;

    final double profileImageHeight =
    myProvider.orientation == 'landscape'
        ? size.height * 0.28
        : size.height * 0.44;

    return Consumer<BackgroundOverlayLogoProvider>(
      builder: (
          BuildContext context,
          BackgroundOverlayLogoProvider provider,
          Widget? child,
          ) {
        final bool hasBackgroundImage =
            provider.selectedBackgroundImage != null &&
                provider.isBackgroundVisible;

        return Scaffold(
          backgroundColor: hasBackgroundImage
              ? Colors.transparent
              : Theme.of(context).brightness ==
              Brightness.dark
              ? const Color(0xff222222)
              : Colors.white,
          drawer: MainDrawer(),
          appBar: const CustomAppBar(
            hasNotification: false,
          ),
          body: Stack(
            children: [
              // ===================================================
              // BACKGROUND
              // ===================================================

              if (hasBackgroundImage)
                Positioned.fill(
                  child: Image.file(
                    File(
                      provider
                          .selectedBackgroundImage!
                          .path,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),

              // ===================================================
              // MAIN CONTENT
              // ===================================================

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 130,
                      left: 8,
                      right: 8,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: profileImageWidth,
                        height:
                        profileImageHeight + 15,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            // =====================================
                            // FLUTTER STUDIO
                            // =====================================

                            ProfileImageWithBanners(
                              isZoomVisible:
                              _isZoomVisible,
                              profileImageWidth:
                              profileImageWidth,
                              profileImageHeight:
                              profileImageHeight,
                              onZoomIconClick:
                              _onZoomIconClick,
                              onProfileImageClick:
                              _onProfileImageClick,
                              layout:
                              _currentLayout,
                            ),

                            // =====================================
                            // LOGO
                            // =====================================

                             LogoWidget(),

                            // =====================================
                            // WEB CANVAS COMPOSITOR
                            //
                            // موجود داخل الصفحة لكنه لا يغطي
                            // استوديو Flutter.
                            // =====================================

                            const Positioned(
                              top: 0,
                              left: 0,
                              width: 2,
                              height: 2,
                              child: IgnorePointer(
                                ignoring: true,
                                child: Opacity(
                                  opacity: 0.01,
                                  child:
                                  MobileStudioWebView(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // =================================================
                  // CONTROL BUTTONS
                  // =================================================

                  Center(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 40,
                      ),
                      child: ControlButtonsRow(
                        currentLayout:
                        _currentLayout,
                        onLayoutChanged: (
                            String layout,
                            ) {
                          setState(() {
                            _currentLayout =
                                layout;
                          });
                        },
                        micOn: _micOn,
                        camOn: _camOn,
                        iconSize: iconSize,
                        isSmall: isSmall,
                        toggleMic: () {
                          requestMicPermission(
                            context,
                            _toggleMic,
                          );
                        },
                        toggleCam: () {
                          requestCameraPermission(
                            context,
                            _toggleCamera,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // ===================================================
              // EXPANDED TOOLS
              // ===================================================

              const Positioned(
                left: 0,
                right: 0,
                bottom: 110,
                child: ExpandToolsWidget(),
              ),

              // ===================================================
              // COMMENTS OVERLAY
              // ===================================================

              if (myProvider.isOverlayEnabled)
                const CommentOverlayWidget(),
            ],
          ),
        );
      },
    );
  }

  void _onProfileImageClick() {
    setState(() {
      _isZoomVisible =
      !_isZoomVisible;
    });
  }

  void _onZoomIconClick() {
    Navigator.pushNamed(
      context,
      '/full_image',
    );
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