import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showEditBillingInfoDialog(BuildContext context) {
  final theme = Theme.of(context);

  final primaryColor = theme.primaryColor;
  final baseTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
  final borderColor = theme.dividerColor;
  final fillColor = theme.cardColor;

  final inputDecoration = InputDecoration(
    filled: true,
    fillColor: fillColor,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: primaryColor, width: 1.5), 
    ),
  );

  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: fillColor,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'edit_billing_info'.tr(),
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: baseTextColor,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: _buildLabeledField('name'.tr(), inputDecoration, theme),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: _buildLabeledField('vat_tax_id'.tr(), inputDecoration, theme),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabeledField('address'.tr(), inputDecoration, theme),
            const SizedBox(height: 12),
            _buildLabeledField('', inputDecoration, theme),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildLabeledField('city'.tr(), inputDecoration, theme)),
                const SizedBox(width: 12),
                Expanded(child: _buildLabeledField('region'.tr(), inputDecoration, theme)),
                const SizedBox(width: 12),
                Expanded(child: _buildLabeledField('postal_code'.tr(), inputDecoration, theme)),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'country_region'.tr(),
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: baseTextColor,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Text(
                      'select_your_country'.tr(),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: theme.brightness == Brightness.dark  
                            ? primaryColor: baseTextColor, 
                      ),
                    ),
                    items:  [
                      DropdownMenuItem(value: 'C', child: Text('cairo'.tr())),
                      DropdownMenuItem(value: 'A', child: Text('alex'.tr())),
                    ],
                    onChanged: (value) {},
                    buttonStyleData: ButtonStyleData(
                      height: 44,
                      width: double.infinity,
                      padding: const EdgeInsets.only(left: 12, right: 36),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: borderColor),
                        color: fillColor,
                      ),
                      elevation: 0,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: primaryColor, //  primary Color
                      ),
                      iconSize: 24,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: fillColor,
                        border: Border.all(color: borderColor),
                      ),
                      offset: const Offset(0, 4),
                      maxHeight: 200,
                    ),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: baseTextColor,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 36,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor, 
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  'save_info'.tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLabeledField(
  String label,
  InputDecoration decoration,
  ThemeData theme,
) {
  final labelColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label.isNotEmpty) ...[
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 6),
      ],
      TextFormField(
        decoration: decoration.copyWith(labelText: null),
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: labelColor,
        ),
      ),
    ],
  );
}
