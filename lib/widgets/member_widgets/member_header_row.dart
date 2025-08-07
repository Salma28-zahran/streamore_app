import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberHeaderRow extends StatelessWidget {
  const MemberHeaderRow({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "member".tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: mq.width * 0.025,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * 0.15),
          child: Text(
            "role".tr(),
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: mq.width * 0.025,
            ),
          ),
        ),
      ],
    );
  }
}
