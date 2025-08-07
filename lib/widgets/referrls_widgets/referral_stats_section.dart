import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferralStatsSection extends StatelessWidget {
  final Size mq;

  const ReferralStatsSection({super.key, required this.mq});

  Widget _buildStatCard(String titleKey, String count, BuildContext context) {
    return Container(
      width: mq.width * 0.92,
      height: mq.height * 0.1,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff5E5E66), width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: mq.width * 0.04,
          top: mq.height * 0.015,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  titleKey.tr(),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: mq.width * 0.048,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: mq.width * 0.04),
                  child: Text(
                    count,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: mq.width * 0.054,
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "share_your_referral_link_with_others".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: mq.width * 0.032,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatCard("clicks", "0", context),
        SizedBox(height: mq.height * 0.012),
        _buildStatCard("sign_ups", "0", context),
        SizedBox(height: mq.height * 0.012),
        _buildStatCard("referrals", "0", context),
        SizedBox(height: mq.height * 0.012),
        Container(
          width: mq.width * 0.92,
          height: mq.height * 0.19,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xff5E5E66), width: 1),
          ),
          padding: EdgeInsets.all(mq.width * 0.04),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.attach_money,
                size: mq.width * 0.23,
                color: Colors.black,
              ),
              SizedBox(width: mq.width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "total_earned".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: mq.width * 0.042,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "3",
                          style: GoogleFonts.poppins(
                            fontSize: mq.width * 0.042,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "claimed_credit".tr(),
                          style: GoogleFonts.poppins(
                            fontSize: mq.width * 0.038,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          "3",
                          style: GoogleFonts.poppins(
                            fontSize: mq.width * 0.038,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: mq.height * 0.015),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: mq.width * 0.03,
                        vertical: mq.height * 0.007,
                      ),
                      color: Color(0xffF2F2F2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "available_credit".tr(),
                            style: GoogleFonts.poppins(
                              fontSize: mq.width * 0.038,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "3",
                            style: GoogleFonts.poppins(
                              fontSize: mq.width * 0.038,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
