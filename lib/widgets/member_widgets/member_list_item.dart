import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MemberListItem extends StatelessWidget {
  final Map<String, String> member;
  final VoidCallback onRemove;
  final double fontSize;
  final double iconSize;

  const MemberListItem({
    super.key,
    required this.member,
    required this.onRemove,
    required this.fontSize,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height * 0.005),
      child: Container(
        height: mq.height * 0.055,
        padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(member['email'] ?? '',
                style: GoogleFonts.poppins(fontSize: fontSize)),
            Row(
              children: [
                Text(member['role'] ?? '',
                    style: GoogleFonts.poppins(fontSize: fontSize)),
                SizedBox(width: mq.width * 0.025),
                IconButton(
                  icon: Icon(Icons.remove_circle, color: Colors.red),
                  iconSize: iconSize,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onRemove,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
