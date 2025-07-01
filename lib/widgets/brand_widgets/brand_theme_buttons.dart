import 'package:easy_localization/easy_localization.dart';
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

Widget buildThemeButton({
  required BuildContext context,
  required String theme,
  required String selectedTheme,
  required Function(String) onSelect,
  required Color primaryColor,
  required ThemeMode themeMode,
  required String font,
}) {
  final bool isSelected = theme == selectedTheme;
  final bool isDark = themeMode == ThemeMode.dark;
  Color bgColor = isDark ? const Color(0xff0D142A) : const Color(0xffEFEFEF);

  switch (theme) {
    case 'minimal':
      return _buildMinimalButton(theme, isSelected, primaryColor, bgColor, onSelect, font);
    case 'bubble':
      return _buildBubbleButton(theme, isSelected, primaryColor, bgColor, onSelect, font);
    case 'news':
      return _buildNewsButton(theme, isSelected, primaryColor, bgColor, onSelect, font);
    default:
      return const SizedBox();
  }
}

Widget _buildMinimalButton(String theme, bool isSelected, Color primaryColor, Color bgColor, Function(String) onSelect, String font) {
  return GestureDetector(
    onTap: () => onSelect(theme),
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: isSelected ? primaryColor : const Color(0xffC8C8C8)),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 12, height: 23, color: primaryColor),
            const SizedBox(width: 5),
            Container(
              width: 62,
              height: 22,
              color: Colors.white,
              child: Center(
                child: Text(
                  'minimal'.tr(),
                  style: getFontStyle(font, fontSize: 12, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildBubbleButton(String theme, bool isSelected, Color primaryColor, Color bgColor, Function(String) onSelect, String font) {
  return GestureDetector(
    onTap: () => onSelect(theme),
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: isSelected ? primaryColor : const Color(0xffC8C8C8)),
      ),
      child: Center(
        child: Container(
          width: 62,
          height: 23,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              'bubble'.tr(),
              style: getFontStyle(font, fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildNewsButton(String theme, bool isSelected, Color primaryColor, Color bgColor, Function(String) onSelect, String font) {
  return GestureDetector(
    onTap: () => onSelect(theme),
    child: Container(
      height: 55,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xffC8C8C8)),
      ),
      child: Center(
        child: Container(
          width: 70,
          height: 23,
          decoration: BoxDecoration(
            color: primaryColor,
            border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade400),
          ),
          child: Center(
            child: Text(
              'news'.tr(),
              style: getFontStyle(font, fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}
