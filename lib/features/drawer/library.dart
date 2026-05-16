import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart' show FontAwesomeIcons;
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/features/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class Library extends StatelessWidget {
  static const String routeName = "/library";

  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasNotification = false;

    return Scaffold(
      appBar: CustomAppBar(hasNotification: false),


      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(left: 21,right: 21),
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
                 Text("you_have_no_recordings_at_the_moment".tr(),style:
                 GoogleFonts.poppins(
                   fontWeight: FontWeight.w400,
                   fontSize: 14
                 ),),
                 SizedBox(height: 10),

                 ElevatedButton(onPressed: (){
                   Navigator.pushNamed(context, '/stream');
                 },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Theme.of(context).colorScheme.primary
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
