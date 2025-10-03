import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/provider/comment_provider.dart';
import '../../../widgets/save_username_widgets/save_username.dart';

class StarredCommentsList extends StatelessWidget {
  final CommentProvider commentProvider;
  final void Function(int) onDeleteComment;

  const StarredCommentsList({
    super.key,
    required this.commentProvider,
    required this.onDeleteComment,
  });

  @override
  Widget build(BuildContext context) {
    final starredComments = commentProvider.comments.asMap().entries.where(
          (entry) => commentProvider.isCommentStarred(entry.key),
    ).toList();

    if (starredComments.isEmpty) {
      return Center(
        child: Text(
          "no_starred_comments".tr(),
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: starredComments.length,
      itemBuilder: (context, index) {
        final entry = starredComments[index];
        final i = entry.key;           // index الأصلي للكومنت
        final commentText = entry.value;

        final isTapped = commentProvider.tappedComments.contains(i);
        final isShown = commentProvider.shownCommentIndex == i;
        final isStarred = commentProvider.isCommentStarred(i);

        return GestureDetector(
          onTap: () {
            commentProvider.toggleCommentTapped(i);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: isTapped
                ? _buildCommentRow(
              context,
              index: i,
              comment: commentText,
              isShown: isShown,
              isStarred: isStarred,
              onShowHideTap: () =>
                  commentProvider.toggleCommentShown(i),
              onStarTap: () =>
                  commentProvider.toggleStarredComment(i),
              onDeleteTap: () => onDeleteComment(i),
            )
                : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFFBDBDBD),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (isStarred)
                            const Icon(
                              Icons.star,
                              size: 17,
                              color: Color(0xFF1865E8),
                            ),
                          const SizedBox(width: 4),
                          UserNameWidget(
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF5E5E66),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        commentText,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Color(0xFF555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCommentRow(
      BuildContext context, {
        required int index,
        required String comment,
        required bool isShown,
        required bool isStarred,
        required VoidCallback onShowHideTap,
        required VoidCallback onStarTap,
        required VoidCallback onDeleteTap,
      }) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Opacity(
                  opacity: 0.2,
                  child: Text(
                    comment,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isStarred ? Icons.star : Icons.star_border,
                      color: isStarred ? const Color(0xFFFFC130) : Colors.black,
                    ),
                    onPressed: onStarTap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.black87),
                    onPressed: onDeleteTap,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: onShowHideTap,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isShown
                      ? Icons.remove_circle_outline
                      : Icons.add_circle_outline,
                  color: Colors.black.withOpacity(0.7),
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  isShown ? "hide".tr() : "show".tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
