import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

import '../../../widgets/referrls_widgets/referral_header_section.dart';
import '../../../widgets/referrls_widgets/referral_stats_section.dart';

class Referrals extends StatefulWidget {
  static const String routeName = "/referrals";

  const Referrals({super.key});

  @override
  State<Referrals> createState() => _ReferralsState();
}

class _ReferralsState extends State<Referrals> {
  bool _isOverlayEnabled2 = false;

  @override
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar(hasNotification: false),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: mq.width * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: mq.height * 0.02),
              ReferralHeaderSection(
                mq: mq,
                isOverlayEnabled: _isOverlayEnabled2,
                onSwitchChanged: (val) => setState(() => _isOverlayEnabled2 = val),
              ),
              SizedBox(height: mq.height * 0.016),
              ReferralStatsSection(mq: mq),
            ],
          ),
        ),
      ),
    );
  }

}
