import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showEditBillingInfoDialog(BuildContext context) {
  final theme = Theme.of(context);
  final isLight = theme.brightness == Brightness.light;

  final baseTextColor =
      isLight ? Colors.black : theme.textTheme.bodyLarge?.color;
  final borderColor = isLight ? Colors.grey.shade600 : theme.dividerColor;
  final fillColor = isLight ? Colors.white : theme.cardColor;

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
      borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
    ),
  );

  showDialog(
    context: context,
    builder:
        (context) => Dialog(
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
                      child: _buildLabeledField(
                        'Name',
                        inputDecoration,
                        theme,
                        isLight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      flex: 2,
                      child: _buildLabeledField(
                        'VAT/Tax ID',
                        inputDecoration,
                        theme,
                        isLight,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildLabeledField('Address', inputDecoration, theme, isLight),
                const SizedBox(height: 12),
                _buildLabeledField('', inputDecoration, theme, isLight),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledField(
                        'City',
                        inputDecoration,
                        theme,
                        isLight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLabeledField(
                        'Region',
                        inputDecoration,
                        theme,
                        isLight,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildLabeledField(
                        'Postal Code',
                        inputDecoration,
                        theme,
                        isLight,
                      ),
                    ),
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
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(value: 'C', child: Text('Cairo')),
                        DropdownMenuItem(value: 'A', child: Text('Alex')),
                      ],
                      onChanged: (value) {},
                      decoration: inputDecoration.copyWith(
                        hintText: 'Select your country',
                        hintStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          color: theme.hintColor,
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: baseTextColor,
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
                      backgroundColor: theme.primaryColor,
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
                        color: Colors.white,
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
  bool isLight,
) {
  final labelColor = isLight ? Colors.black : theme.textTheme.bodyLarge?.color;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (label.isNotEmpty)
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
      if (label.isNotEmpty) const SizedBox(height: 6),
      TextFormField(
        decoration: decoration.copyWith(labelText: null),
        style: GoogleFonts.poppins(fontSize: 13, color: labelColor),
      ),
    ],
  );
}
