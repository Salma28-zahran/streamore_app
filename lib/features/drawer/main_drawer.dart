import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/drawer/contact_us_screen.dart';

import '../../../widgets/save_username_widgets/save_username.dart';
import 'privacy_policy.dart';

class MainDrawer extends StatefulWidget {
  static const String routeName = "/drawer";

  MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int selectedIndex = 0;

  Widget buildDrawerItem(int index, IconData icon, String title) {
    bool isSelected = index == selectedIndex;
    final mq = MediaQuery.of(context).size;
    var myprovider = Provider.of<MyProvider>(context);

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        if (title == "Theme") {
          context.read<MyProvider>().changeTheme();
        } else if (title == "home".tr()) {
          Navigator.pushNamed(context, "/stream");
        } else if (title == "destination".tr()) {
          Navigator.pushNamed(context, '/destination');
        } else if (title == "members".tr()) {
          Navigator.pushNamed(context, '/members');
        } else if (title == "library".tr()) {
          Navigator.pushNamed(context, '/library');
        } else if (title == "referrals".tr()) {
          Navigator.pushNamed(context, '/referrals');
        } else if (title == "settings".tr()) {
          Navigator.pushNamed(context, '/Settings');
        } else if (title == "signout".tr()) {
          Navigator.pushNamed(context, '/signin');
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mq.width * 0.041,
          vertical: mq.height * 0.014,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: mq.width * 0.02,
          vertical: mq.height * 0.004,
        ),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4D8EFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(mq.width * 0.03),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).tabBarTheme.labelColor
                  : Theme.of(context).tabBarTheme.unselectedLabelColor,
            ),
            SizedBox(width: mq.width * 0.041),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: mq.width * 0.041,
                color: isSelected
                    ? Theme.of(context).tabBarTheme.labelColor
                    : Theme.of(context).tabBarTheme.unselectedLabelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyProvider>(context);
    bool isDark = myprovider.themeMode == ThemeMode.dark;
    Size mq = MediaQuery.of(context).size;

    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      width: mq.width * 0.89,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Theme.of(context).cardColor,
                  padding: EdgeInsets.all(mq.width * 0.041),
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    "assets/images/app_name2.png",
                    height: mq.height * 0.05,
                    width: mq.width * 0.46,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: mq.width * 0.044),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<MyProvider>().changeTheme();
                        },
                        child: Icon(
                          isDark ? Icons.wb_sunny : Icons.dark_mode,
                          size: mq.width * 0.064,
                          color: isDark
                              ? Colors.amber
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Text(
                          context.locale.languageCode == 'en' ? 'AR' : 'EN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: mq.width * 0.041,
                          ),
                        ),
                        onPressed: () {
                          if (context.locale.languageCode == 'en') {
                            context.setLocale(const Locale('ar'));
                          } else {
                            context.setLocale(const Locale('en'));
                          }

                          print("Switched to ${context.locale.languageCode}");
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: mq.height * 0.006),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: mq.width * 0.051,
                vertical: mq.height * 0.014,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: mq.width * 0.036,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFBBDEFB),
                borderRadius: BorderRadius.circular(mq.width * 0.03),
              ),
              alignment: Alignment.centerLeft,
              child: const UserNameWidget(),
            ),
            Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
              indent: mq.width * 0.127,
              endIndent: mq.width * 0.127,
            ),
            SizedBox(height: mq.height * 0.019),
            buildDrawerItem(0, Icons.grid_view, "home".tr()),
            buildDrawerItem(1, Icons.share, "destination".tr()),
            buildDrawerItem(2, Icons.group, "members".tr()),
            buildDrawerItem(3, Icons.video_library, "library".tr()),
            buildDrawerItem(5, FontAwesomeIcons.gift, "referrals".tr()),
            buildDrawerItem(6, Icons.settings_outlined, "settings".tr()),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                left: mq.width * 0.099,
                right: mq.width * 0.099,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, ContactUsScreen.routeName);
                    },
                    child: Text(
                      "contact_us".tr(),
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xffAFAFAF),
                        fontSize: mq.width * 0.041,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: mq.width * 0.114),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text(
                      "help_center".tr(),
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xffAFAFAF),
                        fontSize: mq.width * 0.041,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: mq.height * 0.018),
            Padding(
              padding: EdgeInsets.only(
                left: mq.width * 0.099,
                right: mq.width * 0.099,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text(
                      "news".tr(),
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xffAFAFAF),
                        fontSize: mq.width * 0.041,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(width: mq.width * 0.203),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PrivacyPolicy.routeName,
                      );
                    },
                    child: Text(
                      "our_policies".tr(),
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xffAFAFAF),
                        fontSize: mq.width * 0.041,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}