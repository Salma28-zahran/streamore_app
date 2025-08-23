import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:streamore_app/features/tabs/brand/brand_utils/font_utils.dart';

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
      return _buildMinimalButton(context, theme, isSelected, primaryColor, bgColor, onSelect, font);
    case 'bubble':
      return _buildBubbleButton(context, theme, isSelected, primaryColor, bgColor, onSelect, font);
    case 'news':
      return _buildNewsButton(context, theme, isSelected, primaryColor, bgColor, onSelect, font);
    default:
      return const SizedBox();
  }
}

Widget _buildMinimalButton(
    BuildContext context,
    String theme,
    bool isSelected,
    Color primaryColor,
    Color bgColor,
    Function(String) onSelect,
    String font,
    ) {
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
                  style: getFontStyle(context, font, fontSize: 12, color: Colors.black87),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildBubbleButton(
    BuildContext context,
    String theme,
    bool isSelected,
    Color primaryColor,
    Color bgColor,
    Function(String) onSelect,
    String font,
    ) {
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
              style: getFontStyle(context, font, fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildNewsButton(
    BuildContext context,
    String theme,
    bool isSelected,
    Color primaryColor,
    Color bgColor,
    Function(String) onSelect,
    String font,
    ) {
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
              style: getFontStyle(context, font, fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}
