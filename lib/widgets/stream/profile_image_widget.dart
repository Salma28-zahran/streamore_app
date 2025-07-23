import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  final bool isZoomVisible;
  final double profileImageWidth;
  final double profileImageHeight;
  final VoidCallback onZoomClick;
  final VoidCallback onProfileClick;
  final Widget themeOverlay;
  final List<Widget> comments;

  const ProfileImageWidget({
    super.key,
    required this.isZoomVisible,
    required this.profileImageWidth,
    required this.profileImageHeight,
    required this.onZoomClick,
    required this.onProfileClick,
    required this.themeOverlay,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onProfileClick,
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
              onTap: onZoomClick,
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
          child: themeOverlay,
        ),
        Positioned(
          bottom: 100,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: comments,
          ),
        ),
      ],
    );
  }
}
