import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/provider/my_provider.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';
import 'package:provider/provider.dart';

class PrivacyPolicy extends StatelessWidget {
  static const String routeName = "/privacy";

  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final myprovider = Provider.of<MyProvider>(context);
    final isDark = myprovider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: const CustomAppBar(hasNotification: false),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.06, top: mq.height * 0.025,right:mq.width * 0.06 ),
              child: Text(
                "privacy_policy".tr(),
                style: GoogleFonts.poppins(
                  fontSize: mq.width * 0.085,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.06,right:mq.width * 0.06),
              child: Text(
                "section_i".tr(),
                style: GoogleFonts.poppins(
                  fontSize: mq.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.06,right:mq.width * 0.06),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: mq.width * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "using_the_site".tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "https://streamore.com",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text:
                          "link".tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.06,right:mq.width * 0.06),
              child: Text(
                "section_ii".tr(),
                style: GoogleFonts.poppins(
                  fontSize: mq.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.06,right:mq.width * 0.06),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: mq.width * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "using_the_site".tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "https://streamore.com",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text:
                      "link".tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.06,right:mq.width * 0.06),
              child: Text(
                "section_iii".tr(),
                style: GoogleFonts.poppins(
                  fontSize: mq.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: mq.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: mq.width * 0.06,right:mq.width * 0.06),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: mq.width * 0.04,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: "using_the_site".tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "https://streamore.com",
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text:
                      "link".tr(),
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                    ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
