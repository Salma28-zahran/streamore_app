import 'dart:io';

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/background-overlay-logo_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';

class ProfileImageWidget extends StatelessWidget {
  final bool isZoomVisible;
  final double profileImageWidth;
  final double profileImageHeight;
  final VoidCallback onZoomClick;
  final VoidCallback onProfileClick;
  final Widget themeOverlay;
  final Participant participant;

  const ProfileImageWidget({
    super.key,
    required this.isZoomVisible,
    required this.profileImageWidth,
    required this.profileImageHeight,
    required this.onZoomClick,
    required this.onProfileClick,
    required this.themeOverlay,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    final cameraPublication =
    participant.getTrackPublicationBySource(
      TrackSource.camera,
    );

    final VideoTrack? cameraTrack =
    cameraPublication?.track is VideoTrack
        ? cameraPublication!.track as VideoTrack
        : null;

    final provider = context.watch<MyProvider>();

    final overlayProvider =
    context.watch<BackgroundOverlayLogoProvider>();

    return Stack(
      children: [
        GestureDetector(
          onTap: onProfileClick,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: profileImageWidth,
              height: profileImageHeight,
              child: cameraTrack != null
                  ? VideoTrackRenderer(
                cameraTrack,
              )
                  : overlayProvider.selectedOverlayImage != null
                  ? Image.file(
                File(
                  overlayProvider
                      .selectedOverlayImage!
                      .path,
                ),
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/profile5.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        if (isZoomVisible)
          Positioned(
            top: profileImageHeight / 2 - 27,
            left: profileImageWidth / 2 - 27,
            child: GestureDetector(
              onTap: onZoomClick,
              child: Container(
                padding: const EdgeInsets.all(2),
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

        if (provider.isOverlayEnabled)
          Positioned(
            bottom: 0,
            left: 0,
            child: themeOverlay,
          ),
      ],
    );
  }
}