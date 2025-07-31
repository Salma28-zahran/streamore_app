import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/provider/my_provider.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class ForgetPass1 extends StatelessWidget {
  static const String routeName = "/forget_pass1";

  const ForgetPass1({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;
    final double hp = w * 0.06;
    final myprovider = Provider.of<MyProvider>(context);
    final bool isDark = myprovider.themeMode == ThemeMode.dark;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: CustomAppBar(hasNotification: false),

      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: h * 0.12),
          Center(child: Image.asset("assets/images/app_name2.png")),
          SizedBox(height: h * 0.04),
          Text(
            "please_verify_your_email".tr(),
            style: GoogleFonts.poppins(
              fontSize: w * 0.05,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: h * 0.006),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.12),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: w * 0.035,
                  color: isDark ? Colors.white : Colors.black,
                ),
                children: [
                  TextSpan(text: "${'enter_your_email_address_to_receive_a'.tr()}\n"),
                  TextSpan(text: "verification_code".tr()),
                ],
              ),
            ),
          ),
          SizedBox(height: h * 0.06),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.08),
            child: Container(
              width: w * 0.9,
              height: h * 0.07,
              color: Theme.of(context).cardColor,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "email".tr(),
                  hintStyle: GoogleFonts.poppins(
                    color: Color(0xff676767),
                    fontSize: w * 0.03,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: h * 0.02,
                    horizontal: w * 0.03,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xffA8A8A9),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Color(0xffA8A8A9),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.07),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forget_pass2');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1865E8),
                  minimumSize: Size(w * 0.38, h * 0.045),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: Text(
                  "send_code".tr(),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: w * 0.03,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.16),
          Text(
            "question_email_us".tr(),
            style: GoogleFonts.poppins(
              fontSize: w * 0.035,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            child: Text(
              "support@Streamore.io",
              style: GoogleFonts.montserrat(
                color: Colors.blue,
                fontSize: w * 0.035,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
