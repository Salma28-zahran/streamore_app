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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 3),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 80,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                "assets/images/profile4.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
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
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF323236),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF679FFF),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Text(
                                "host",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "480p",
                              style: TextStyle(
                                color: Color(0xFF5E5E66),
                                fontSize: 11,
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
                          width: 25,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(
                              isMicOn ? Icons.mic : Icons.mic_off,
                              size: 25,
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
                          width: 25,
                          child: PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.more_vert,
                                size: 25, color: Colors.black),
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.volume_off,
                        size: 20, color: Colors.black54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(
                          10,
                          (index) => Container(
                            width: 18,
                            height: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 2),
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
