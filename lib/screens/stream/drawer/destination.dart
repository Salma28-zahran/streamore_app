import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

class Destination extends StatelessWidget {
  static const String routeName = "/destination";

  const Destination({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: Icon(
              Icons.notification_add,
              color: Theme.of(context).primaryColorDark,
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
              "Add a Destination",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            SizedBox(height: 17),
            Text(
              "Connect an account to Stremore. Once connected, you can stream to it as often as you like.",
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
                  "Custom RTMP",
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
                    text: "Don't see your platform? Choose",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    children: [
                      TextSpan(
                        text: '"Custom RTMP".',
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
