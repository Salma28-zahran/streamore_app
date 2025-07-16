import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getFontStyle(
    String font, {
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.w400,
      Color? color,
    }) {
  switch (font.toLowerCase()) {
    case 'playfair display':
      return GoogleFonts.playfairDisplay(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'pacifico':
      return GoogleFonts.pacifico(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'bebas neue':
      return GoogleFonts.bebasNeue(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'courier prime':
      return GoogleFonts.courierPrime(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'abril fatface':
      return GoogleFonts.abrilFatface(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'caveat':
      return GoogleFonts.caveat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'rubik mono one':
      return GoogleFonts.rubikMonoOne(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'amatic sc':
      return GoogleFonts.amaticSc(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    case 'dm serif display':
      return GoogleFonts.dmSerifDisplay(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
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
