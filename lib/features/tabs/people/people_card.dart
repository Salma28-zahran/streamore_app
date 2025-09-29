import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
          /// الصورة
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

          /// النصوص + الأيقونات + الصوت (كلهم جوه عمود)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// الصف اللي فيه النصوص + الأيقونات
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// الجزء النصي
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Username",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF679FFF),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                "host",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Text(
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

                    /// أيقونات المايك والمنيو
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            isMicOn ? Icons.mic : Icons.mic_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isMicOn = !isMicOn;
                            });
                          },
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.black),
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
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// الصف بتاع الصوت (volume bar)
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
                            margin:
                            const EdgeInsets.symmetric(horizontal: 2),
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
