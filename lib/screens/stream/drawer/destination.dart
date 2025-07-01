import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

class Destination extends StatelessWidget {
  static const String routeName = "/destination";

  const Destination({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasNotification = false;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,

        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color:
            Theme.of(
              context,
            ).appBarTheme.foregroundColor,
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
                      decoration: BoxDecoration(
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
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            height: 1,
          ),
        ),
      ),
      drawer: MainDrawer(),


      body: Padding(
        padding: const EdgeInsets.only(left: 21),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 17),
            Text(
              "add_a_destination".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            SizedBox(height: 17),
            Text(
              "connect_an_account_to_stremore_once_connected_you_can_stream_to_it_as_often_as_you_like".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Image.asset("assets/images/facebook.png",width: 40,height: 40,),
                SizedBox(width: 31),
                Image.asset("assets/images/linkdin.png",width: 40,height: 40,),
                SizedBox(width: 31),
                Image.asset("assets/images/youtube.png",width: 40,height: 40,),
                SizedBox(width: 31),
                Image.asset("assets/images/insta.png",width: 40,height: 40,),
              ],
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset("assets/images/yahoo.png",width: 40,height: 40,),
                SizedBox(width: 31),
                Image.asset("assets/images/x.png",width: 40,height: 40,),



              ],
            ),
            SizedBox(height: 32),
            Row(
              children: [
                Image.asset("assets/images/Vector.png",width: 40,height: 40,),
                SizedBox(width: 9),
                Text(
                  "custom_rtmp",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                    color: Theme.of(context).appBarTheme.foregroundColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 43,),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: "don't_see_your_platform_choose".tr(),
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(
                        text: '"custom_rtmp".'.tr(),
                        style: GoogleFonts.inter(
                          color: Colors.blue,
                          fontSize: 13,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                           // Navigator.pushNamed(context, '/signup');
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
