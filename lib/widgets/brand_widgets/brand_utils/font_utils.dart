import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getFontStyle(String font, {
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.w400,
  Color? color,
}) {
  switch (font.toLowerCase()) {
    case 'poppins':
      return GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'inter':
    default:
      return GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
  }
}
