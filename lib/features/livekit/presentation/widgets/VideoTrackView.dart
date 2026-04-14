import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class VideoTrackView extends StatelessWidget {
  final VideoTrack track;

  const VideoTrackView({super.key, required this.track});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        color: Colors.black,
        child: VideoTrackRenderer(track),
      ),
    );
  }
}