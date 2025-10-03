import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/widgets/save_username_widgets/save_username.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isMicOn = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double w = size.width;
    final double h = size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(w * 0.025),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: w * 0.008),
        borderRadius: BorderRadius.circular(w * 0.02),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: w * 0.15,
            height: h * 0.12,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(w * 0.015),
              child: Image.asset(
                "assets/images/profile4.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: w * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserNameWidget(
                          style: GoogleFonts.poppins(
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF323236),
                          ),
                        ),
                        SizedBox(height: h * 0.01),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: h * 0.003,
                                horizontal: w * 0.025,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF679FFF),
                                borderRadius: BorderRadius.circular(w * 0.01),
                              ),
                              child: Text(
                                "host",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.03,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: w * 0.015),
                            Text(
                              "480p",
                              style: TextStyle(
                                color: const Color(0xFF5E5E66),
                                fontSize: w * 0.028,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: w * 0.065,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              isMicOn ? Icons.mic : Icons.mic_off,
                              size: w * 0.065,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isMicOn = !isMicOn;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: w * 0.065,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.more_vert,
                                size: w * 0.065, color: Colors.black),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: "edit_name",
                                child: Text("edit_name".tr()),
                              ),
                              PopupMenuItem(
                                value: "edit_avatar",
                                child: Text("edit_avatar".tr()),
                              ),
                              PopupMenuItem(
                                value: "remove_person",
                                child: Text("remove_person".tr()),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: h * 0.01),
                Row(
                  children: [
                    Icon(Icons.volume_off,
                        size: w * 0.05,
                        color: Colors.black54),
                    SizedBox(width: w * 0.015),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          10,
                              (index) => Container(
                            width: w * 0.045,
                            height: h * 0.0025,
                            margin: EdgeInsets.symmetric(
                                horizontal: w * 0.005),
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
