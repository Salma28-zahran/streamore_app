import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/my_provider.dart';


class LogoWidget extends StatefulWidget {
  @override
  _LogoWidgetState createState() => _LogoWidgetState();
}

class _LogoWidgetState extends State<LogoWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(
      builder: (context, provider, child) {
        if (!provider.isLogoVisible) return SizedBox();

        return Positioned(
          top: 20,
          right: 40,
          child: GestureDetector(
            onTap: () {
              provider.toggleLogoVisibility();  // Toggle visibility
              setState(() {});  // Force rebuild
            },
            child: Container(
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: provider.logoImageFile != null
                    ? Image.file(
                        File(provider.logoImageFile!.path),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                        height: 50,
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
