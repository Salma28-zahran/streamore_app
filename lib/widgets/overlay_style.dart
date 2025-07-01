import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../my_provider.dart';

Widget buildOverlay(MyProvider provider) {
  final theme = provider.selectedTheme;
  final color = provider.primaryColor;

  switch (theme) {
    case 'Minimal':
      return Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 23,
              color: color,
            ),
            Container(
              width: 67,
              height: 23,
              color: Colors.white,
              child: Center(
                child: Text(
                  'John Doe',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    case 'Bubble':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 73,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              'John Doe',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );

    case 'News':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 76,
          height: 21,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Center(
            child: Text(
              'John Doe',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );

    default:
      return const SizedBox.shrink();
  }
}
