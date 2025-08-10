import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/provider/my_provider.dart';
import 'package:streamore_app/screens/stream/drawer/contact_us_screen.dart';
import 'package:streamore_app/screens/stream/drawer/privacy_policy.dart';

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4D8EFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).tabBarTheme.labelColor
                  : Theme.of(context).tabBarTheme.unselectedLabelColor,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
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
    Size mq = MediaQuery.of(context).size; // ✅ MediaQuery for responsive use

    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      width: 348,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    color: Theme.of(context).cardColor,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.bottomLeft,
                    child: Image.asset("assets/images/app_name.png")),
                Padding(
                  padding: const EdgeInsets.only(right: 17),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<MyProvider>().changeTheme();
                        },
                        child: Icon(
                          isDark ? Icons.wb_sunny : Icons.dark_mode,
                          size: 25,
                          color:
                          isDark ? Colors.amber : Theme.of(context).primaryColor,
                        ),
                      ),
                      IconButton(
                        icon: Text(
                          context.locale.languageCode == 'en' ? 'AR' : 'EN',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
            const SizedBox(height: 5),
            Image.asset("assets/images/my_acc.png", width: 344, height: 44),
            const SizedBox(height: 10),
            Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
              indent: 50,
              endIndent: 50,
            ),
            const SizedBox(height: 16),

            // Main Items
            buildDrawerItem(0, Icons.grid_view, "home".tr()),
            buildDrawerItem(1, Icons.share, "destination".tr()),
            buildDrawerItem(2, Icons.group, "members".tr()),
            buildDrawerItem(3, Icons.video_library, "library".tr()),
            buildDrawerItem(5, FontAwesomeIcons.gift, "referrals".tr()),
            buildDrawerItem(6, Icons.settings_outlined, "settings".tr()),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(left: 39, right: 39),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 45),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text(
                      "help_center".tr(),
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xffAFAFAF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 39, right: 39),
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
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, PrivacyPolicy.routeName);
                    },
                    child: Text(
                      "our_policies".tr(),
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xffAFAFAF),
                        fontSize: 16,
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
