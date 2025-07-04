import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final primaryColor = theme.primaryColor;
  final baseTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
  final borderColor = theme.dividerColor;
  final fillColor = theme.cardColor;
    final media = MediaQuery.of(context).size;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: theme.cardColor,
      insetPadding: EdgeInsets.symmetric(
        horizontal: media.width * 0.06,
        vertical: media.height * 0.08,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: media.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Payment Details",
                style: GoogleFonts.poppins(
                  fontSize: media.width * 0.05,
                  fontWeight: FontWeight.w700,
                  color: Colors.black, 
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "7-day money-back guarantee",
                style: GoogleFonts.poppins(
                  fontSize: media.width * 0.035,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  _InfoBox(label: plan),
                  const SizedBox(width: 12),
                  _InfoBox(label: price),
                ],
              ),
              const SizedBox(height: 16),

              _Label("Card Information", media),
              const SizedBox(height: 6),

              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Card Number',
                  hintStyle:
                      GoogleFonts.poppins(fontSize: media.width * 0.035),
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
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              _Label("Country/Region", media),
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

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Subscribe",
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
    );
  }

  Widget _Label(String text, Size media) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: media.width * 0.035,
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;

  const _InfoBox({required this.label});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Flexible(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: media.width * 0.04,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
