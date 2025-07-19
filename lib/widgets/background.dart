import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:streamore_app/my_provider.dart';

class BackgroundWidget extends StatefulWidget {
  @override
  _BackgroundWidgetState createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, child) {
        if (provider.selectedBackgroundImage == null ||
            !provider.isBackgroundVisible) {
          return SizedBox();
        }

        double profileImageWidth = MediaQuery.of(context).size.width * 0.9425;
        double profileImageHeight = MediaQuery.of(context).size.height * 0.28;

        return Positioned(
          top: 0,
          left: (MediaQuery.of(context).size.width - profileImageWidth) / 2,
          right: (MediaQuery.of(context).size.width - profileImageWidth) / 2,
          child: GestureDetector(
            onTap: () {
              print("Tapped on background!");
              print(
                "selectedBackgroundImage: ${provider.selectedBackgroundImage?.path}",
              );
              provider
                  .toggleBackgroundVisibility(); // Toggle visibility when tapped
            },
            child: Container(
              width: profileImageWidth,
              height: profileImageHeight,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                image: DecorationImage(
                  image:
                      provider.selectedBackgroundImage != null
                          ? FileImage(
                            File(provider.selectedBackgroundImage!.path),
                          )
                          : AssetImage(
                                'assets/images/background_placeholder.png',
                              )
                              as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
