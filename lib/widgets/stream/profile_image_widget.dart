import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/my_provider.dart';


class ProfileImageWidget extends StatelessWidget {
  final bool isZoomVisible;
  final double profileImageWidth;
  final double profileImageHeight;
  final VoidCallback onZoomClick;
  final VoidCallback onProfileClick;
  final Widget themeOverlay;


  const ProfileImageWidget({
    super.key,
    required this.isZoomVisible,
    required this.profileImageWidth,
    required this.profileImageHeight,
    required this.onZoomClick,
    required this.onProfileClick,
    required this.themeOverlay,

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
        if (Provider.of<MyProvider>(context).isOverlayEnabled)
          Positioned(
            bottom: 0,
            left: 0,
            child: themeOverlay,
          ),


      ],
    );
  }
}
