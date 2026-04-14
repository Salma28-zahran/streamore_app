import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

class ParticipantTile extends StatelessWidget {
  final Participant participant;

  const ParticipantTile({
    super.key,
    required this.participant,
  });

  @override
  Widget build(BuildContext context) {
    VideoTrack? videoTrack;

    final tracks = participant.trackPublications.values
        .where((pub) => pub.kind == TrackType.VIDEO && pub.track != null)
        .map((pub) => pub.track)
        .whereType<VideoTrack>();

    if (tracks.isNotEmpty) {
      videoTrack = tracks.first;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          if (videoTrack != null)
            Positioned.fill(
              child: VideoTrackRenderer(videoTrack),
            )
          else
            const Center(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 40,
              ),
            ),

          ///  name
          Positioned(
            left: 8,
            bottom: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              color: Colors.black54,
              child: Text(
                participant.identity,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}