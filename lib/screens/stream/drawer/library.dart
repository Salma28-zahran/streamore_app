import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

class Library extends StatelessWidget {
  static const String routeName = "/library";

  const Library({super.key});

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
            SizedBox(height: 10,),
            Text(
              "library".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 22,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
           Expanded(child: Center(
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 Text("You_have_no_recordings_at_the_moment".tr(),style:
                 GoogleFonts.poppins(
                   fontWeight: FontWeight.w400,
                   fontSize: 14
                 ),),
                 SizedBox(height: 10),

                 ElevatedButton(onPressed: (){
                   Navigator.pushNamed(context, '/stream');
                 },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Theme.of(context).primaryColor
                   ),
                     child: Text("record_now".tr(),
                     style: GoogleFonts.poppins(
                       color: Colors.white,
                       fontSize: 13,
                       fontWeight: FontWeight.w500
                     ),),)
               ],
             ),
           )),

          ],
        ),
      ),


    );
  }
}
