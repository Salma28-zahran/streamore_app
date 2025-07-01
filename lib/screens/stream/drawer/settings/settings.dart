import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/screens/stream/drawer/settings/account_tab.dart';
import 'package:streamore_app/screens/stream/drawer/settings/billing_tab.dart';

class Settings extends StatelessWidget {
  static const String routeName = "/Settings";

  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasNotification = false;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            "Streamore",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Stack(
                children: [
                  Icon(
                    FontAwesomeIcons.bell,
                    color: Theme.of(context).primaryColorDark,
                    size: 24,
                  ),
                  if (hasNotification)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Divider(
              color: Theme.of(context).dividerColor,
              thickness: 1,
              height: 1,
            ),
          ),
        ),
        drawer:  MainDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 23, top: 34),
              child: Text(
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
