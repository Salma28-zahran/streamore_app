import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:streamore_app/features/drawer/main_drawer.dart';
import 'package:streamore_app/features/drawer/settings/account_tab.dart';
import 'package:streamore_app/features/drawer/settings/billing_tab.dart';

import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class Settings extends StatefulWidget {
  static const String routeName = "/Settings";

  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    bool hasNotification = false;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(hasNotification: false),

        drawer:  MainDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23, top: 34,right: 23),
              child:
              Text(
                "settings".tr(),
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 30,left: 23),
              child: TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 2),
                labelStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs:  [
                  Tab(text: "account".tr()),

                  Tab(text: "billing".tr()),
                ],
              ),
            ),

            const SizedBox(height: 12),
            Expanded(
              child: TabBarView(
                children: [
                  AccountTab(),
                  BillingTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
