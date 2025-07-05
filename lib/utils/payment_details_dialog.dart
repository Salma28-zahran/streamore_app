import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui' as ui;

class PaymentDetailsDialog extends StatelessWidget {
  final String plan;
  final String price;

  const PaymentDetailsDialog({
    super.key,
    required this.plan,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context).size;

    final primaryColor = theme.colorScheme.primary;
    final baseGray = theme.textTheme.bodyLarge?.color;
    final fillColor = theme.cardColor;
    final labelColor = theme.colorScheme.onSurface;
    final borderGray = theme.dividerColor;

    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: fillColor,
        insetPadding: EdgeInsets.symmetric(
          horizontal: media.width * 0.06,
          vertical: media.height * 0.08,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: media.height * 0.85),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Label("Payment Details".tr(), labelColor, media),
                const SizedBox(height: 4),
                Text(
                  "7-day money-back guarantee".tr(),
                  style: GoogleFonts.poppins(
                    fontSize: media.width * 0.035,
                    color: baseGray,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _InfoBox(
                      label: plan,
                      color: baseGray!,
                      showBorder: plan.toLowerCase() != 'basic',
                      borderColor: borderGray,
                    ),
                    const SizedBox(width: 12),
                    _InfoBox(
                      label: price,
                      color: baseGray,
                      showBorder: plan.toLowerCase() != 'basic',
                      borderColor: borderGray,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                _Label("Card Information".tr(), labelColor, media),
                const SizedBox(height: 6),

                TextField(
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.poppins(color: baseGray),
                  textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: 'Card Number'.tr(),
                    hintStyle: GoogleFonts.poppins(
                      fontSize: media.width * 0.035,
                      color: baseGray,
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 8),
                      child: Image.asset(
                        'assets/images/payment.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 20,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderGray),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderGray),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                _Label("Country/Region".tr(), labelColor, media),
                const SizedBox(height: 6),

                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'select_your_country'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: baseGray,
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'C', child: Text('Cairo')),
                      DropdownMenuItem(value: 'A', child: Text('Alex')),
                    ],
                    onChanged: (value) {},
                    buttonStyleData: ButtonStyleData(
                      height: 44,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 12, right: 36),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: borderGray),
                        color: fillColor,
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: baseGray,
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: fillColor,
                        border: Border.all(color: borderGray),
                      ),
                      offset: const Offset(0, 4),
                      maxHeight: 200,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: baseGray,
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 48, 
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                    alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Subscribe".tr(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: media.width * 0.04,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Label(String text, Color color, Size media) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: media.width * 0.035,
          color: color,
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool showBorder;
  final Color borderColor;

  const _InfoBox({
    required this.label,
    required this.color,
    this.showBorder = true,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final fill = Theme.of(context).brightness == Brightness.dark
        ? Colors.grey[850]
        : Colors.grey[200];

    return Flexible(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(6),
          border: showBorder
              ? Border.all(color: borderColor)
              : Border.all(color: Colors.transparent),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: media.width * 0.04,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
