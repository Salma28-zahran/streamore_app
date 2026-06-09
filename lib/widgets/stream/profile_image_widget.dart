import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart'
    show VideoTrackRenderer, Participant, TrackType, VideoTrack;
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:collection/collection.dart';

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
  @override
  Widget build(BuildContext context) {
    final videoTrack = participant.trackPublications.values
        .where((p) => p.kind == TrackType.VIDEO && p.track != null)
        .map((p) => p.track)
        .whereType<VideoTrack>()
        .firstOrNull;

    final provider = context.watch<MyProvider>();

    return Stack(
      children: [
        GestureDetector(
          onTap: onProfileClick,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: SizedBox(
              width: profileImageWidth,
              height: profileImageHeight,
              child: videoTrack != null
                  ? VideoTrackRenderer(videoTrack)
                  : Image.asset(
                "assets/images/profile5.png",
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