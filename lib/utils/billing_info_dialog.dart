import 'package:dropdown_button2/dropdown_button2.dart';
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
      borderSide: BorderSide(color: primaryColor, width: 1.5), //primary Color 
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
                'Edit Billing Info',
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
                  child: _buildLabeledField('Name', inputDecoration, theme),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 2,
                  child: _buildLabeledField('VAT/Tax ID', inputDecoration, theme),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabeledField('Address', inputDecoration, theme),
            const SizedBox(height: 12),
            _buildLabeledField('', inputDecoration, theme),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildLabeledField('City', inputDecoration, theme)),
                const SizedBox(width: 12),
                Expanded(child: _buildLabeledField('Region', inputDecoration, theme)),
                const SizedBox(width: 12),
                Expanded(child: _buildLabeledField('Postal Code', inputDecoration, theme)),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Country/Region',
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
                      'Select your country',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: theme.brightness == Brightness.dark  
                            ? primaryColor: baseTextColor, 
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
                  'Save Info',
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
