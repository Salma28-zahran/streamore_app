import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

class Referrals extends StatefulWidget {
  static const String routeName = "/referrals";

  const Referrals({super.key});

  @override
  State<Referrals> createState() => _ReferralsState();
}

class _ReferralsState extends State<Referrals> {
  bool _isOverlayEnabled2 = false;
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
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
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
            thickness: 0.5,
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
            SizedBox(height: 16),
            Text(
              "referral_methods".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            SizedBox(height: 10,),

            Container(
              width: 353,
              height: 153,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff5E5E66),
                  width: 1
                )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 12,top: 10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.scale(
                          scaleX: 28 / 59,
                          scaleY: 13 / 34,
                          child: Switch(
                            value: _isOverlayEnabled2,
                            onChanged: (value) {
                              setState(() {
                                _isOverlayEnabled2 = value;
                              });
                            },
                          ),
                        ),

                        SizedBox(width: 2,),
                        Container(
                          width: 273,
                          height: 38,
                          child: Text("include_your_referral_link_in_your_upcoming_stream".tr(),
                            style:GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12
                            ) ,),

                        ),

                      ],

                    ),
                    Divider(
                      thickness: 1,
                      color: Theme.of(context).dividerColor,
                      indent: 2,
                      endIndent: 2,
                    ),
                    Row(
                      children: [
                        Text("share_your_referral_link_with_others".tr(),
                      style:GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 12
                      ) ,),
                      ],
                    ),
                    SizedBox(height: 10,),

                    Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 218,
                        height: 34,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "your_referral_link".tr(),
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w400
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2),
                            ),
                            filled: true,
                           fillColor: Theme.of(context).iconTheme.color
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            ),
            SizedBox(height: 37,),

            Text(
              "stats".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
            Container(
              width: 350,
              height: 76,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color(0xff5E5E66),
                      width: 1
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14,top: 12),
                child: Column(
                  children: [

                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("clicks".tr(),
                            style:GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 18
                            ) ,),
                          Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: Text("0",
                              style:GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20
                              ) ,),
                          ),
                        ],
                      ),

                    Align(alignment: Alignment.topLeft,
                      child: Text("share_your_referral_link_with_others".tr(),
                        style:GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ) ,),
                    ),

                  ],
                        ),
              ),
            ),
            SizedBox(height: 10,),

            Container(
              width: 350,
              height: 76,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color(0xff5E5E66),
                      width: 1
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14,top: 12),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("sign_ups".tr(),
                          style:GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                          ) ,),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text("0",
                            style:GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                            ) ,),
                        ),
                      ],
                    ),

                    Align(alignment: Alignment.topLeft,
                      child: Text("share_your_referral_link_with_others".tr(),
                        style:GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ) ,),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: 350,
              height: 76,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color(0xff5E5E66),
                      width: 1
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 14,top: 12),
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("referrals".tr(),
                          style:GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                          ) ,),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Text("0",
                            style:GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 20
                            ) ,),
                        ),
                      ],
                    ),

                    Align(alignment: Alignment.topLeft,
                      child: Text("share_your_referral_link_with_others".tr(),
                        style:GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 12
                        ) ,),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),

            Container(
              width: 350,
              height: 144,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xff5E5E66), width: 1),

              ),
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 90,
                    color: Colors.black,
                  ),
                  SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "total_earned".tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "3",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "claimed_credit".tr(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              "3",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 13),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xffF2F2F2),

                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "available_credit".tr(),
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                "3",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
