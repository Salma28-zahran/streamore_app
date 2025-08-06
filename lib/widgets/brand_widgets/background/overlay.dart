import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/background-overlay-logo_provider.dart';
import 'package:streamore_app/provider/my_provider.dart';

class OverlayWidget extends StatefulWidget {
  @override
  _OverlayWidgetState createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<BackgroundOverlayLogoProvider>(
      builder: (context, provider, child) {
        if (!provider.isOverlayVisible) return SizedBox();

        double screenWidth = MediaQuery.of(context).size.width;
        double screenHeight = MediaQuery.of(context).size.height;

        double frameWidth = screenWidth * 0.7;
        double frameHeight = screenHeight * 0.25;
        double frameTop = screenHeight * 0.03;

        double horizontalPadding = (screenWidth - frameWidth) / 2;

        return Positioned(
          top: frameTop,
          left: horizontalPadding,
          right: horizontalPadding,
          child: GestureDetector(
            // onTap: () {
            //   // Toggle the visibility of the overlay on tap
            //   provider.toggleOverlayVisibility();
            // },
            child: Container(
              width: frameWidth,
              height: frameHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Container(
                width: frameWidth,
                height: frameHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: provider.selectedOverlayImage != null
                        ? FileImage(File(provider.selectedOverlayImage!.path))
                        : AssetImage('assets/images/overlay_placeholder.png')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
