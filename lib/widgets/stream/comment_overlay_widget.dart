import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:streamore_app/widgets/save_username_widgets/save_username.dart';

class CommentOverlayWidget extends StatelessWidget {
  const CommentOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: screenHeight * 0.026,
      right: screenWidth * 0.05,
      child: Container(
        width: screenWidth * 0.35,
        height: screenHeight * 0.26,
        padding:  EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Consumer<CommentProvider>(
          builder: (context, commentProvider, _) {
            final comments = commentProvider.comments;

            if (comments.isEmpty) {
              return  Center(
                child: Text(
                  "no_comments".tr(),
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              );
            }

            return ListView.builder(
              reverse: false,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Container(
                  margin:  EdgeInsets.symmetric(vertical: 4),
                  padding:  EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0xFF32323663),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 14, color: Colors.white),
                      ),
                       SizedBox(width: 6),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserNameWidget(
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5E5E66),
                              ),

                            ),


                             SizedBox(height: 3),
                            Text(
                              comment,
                              style: GoogleFonts.inter(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w600,
                                fontSize: 7,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
