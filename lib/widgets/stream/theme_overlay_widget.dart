import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:streamore_app/core/provider/comment_provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/utils/brand_utils/font_utils.dart';

import 'package:provider/provider.dart';

class ThemeOverlayWidget extends StatelessWidget {
  final MyProvider provider;

  const ThemeOverlayWidget({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = provider.selectedTheme;
    final color = provider.primaryColor;
    final font = provider.selectedFont;
    final commentProvider = Provider.of<CommentProvider>(context);
    final displayedText = commentProvider.shownCommentText != null
        ? commentProvider.shownCommentText!
        : "user_name".tr();



    switch (theme) {
      case 'bubble':
        return Padding(
          padding: EdgeInsets.all(11),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              displayedText,
              style: getFontStyle(
                context,
                font,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        );
      case 'minimal':
        return Padding(
          padding: EdgeInsets.only(bottom: 11),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 24, color: color),
                Container(
                  width: 76,
                  height: 23,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      displayedText,
                      style: getFontStyle(
                        context,
                        font,
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      case 'news':
      default:
        return Padding(
          padding: EdgeInsets.all(11),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(0),
            ),
            child: Text(
              displayedText,
              style: getFontStyle(
                context,
                font,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        );
    }
  }
}
