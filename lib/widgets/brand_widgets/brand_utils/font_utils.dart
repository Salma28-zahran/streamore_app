import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getFontStyle(
    BuildContext context,
    String font, {
      double fontSize = 14,
      FontWeight fontWeight = FontWeight.w400,
      Color? color,
    }) {
  bool isArabic = Directionality.of(context) == TextDirection.rtl;

  if (isArabic) {
    switch (font.toLowerCase()) {
      case 'cairo':
        return GoogleFonts.cairo(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'amiri':
        return GoogleFonts.amiri(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'lalezar':
        return GoogleFonts.lalezar(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'tajawal':
        return GoogleFonts.tajawal(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'changa':
        return GoogleFonts.changa(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'reem kufi':
        return GoogleFonts.reemKufi(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'almarai':
        return GoogleFonts.almarai(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'el messiri':
        return GoogleFonts.elMessiri(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'noto kufi arabic':
        return GoogleFonts.notoKufiArabic(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      case 'harmattan':
        return GoogleFonts.harmattan(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
      default:
        return GoogleFonts.tajawal( // fallback عربي
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        );
    }
  }

  // الإنجليزية
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
