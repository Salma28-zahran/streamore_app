import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferralHeaderSection extends StatelessWidget {
  final Size mq;
  final bool isOverlayEnabled;
  final ValueChanged<bool> onSwitchChanged;

  const ReferralHeaderSection({
    super.key,
    required this.mq,
    required this.isOverlayEnabled,
    required this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "referral_methods".tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: mq.width * 0.052,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        SizedBox(height: mq.height * 0.012),
        Container(
          width: mq.width * 0.92,
          height: mq.height * 0.19,
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xff5E5E66),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: mq.width * 0.032,
              top: mq.height * 0.012,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scaleX: 28 / 59,
                      scaleY: 13 / 34,
                      child: Switch(
                        value: isOverlayEnabled,
                        onChanged: onSwitchChanged,
                      ),
                    ),
                    SizedBox(width: mq.width * 0.0056),
                    Container(
                      width: mq.width * 0.72,
                      height: mq.height * 0.05,
                      child: Text(
                        "include_your_referral_link_in_your_upcoming_stream".tr(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: mq.width * 0.032,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Theme.of(context).dividerColor,
                  indent: 2,
                  endIndent: 2,
                ),
                Row(
                  children: [
                    Text(
                      "share_your_referral_link_with_others".tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: mq.width * 0.032,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mq.height * 0.012),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: mq.width * 0.58,
                    height: mq.height * 0.045,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "your_referral_link".tr(),
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: mq.width * 0.03,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).iconTheme.color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: mq.height * 0.010),
        Text(
          "stats".tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: mq.width * 0.052,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        SizedBox(height: mq.height * 0.010),
      ],
    );
  }
}
