import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../provider/my_provider.dart';
import 'package:streamore_app/provider/my_provider.dart';
import 'package:streamore_app/provider/comment_provider.dart';

class CommentsTab extends StatefulWidget {
  static const String routeName = "/comments";

  const CommentsTab({super.key});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  final TextEditingController _controller = TextEditingController();

  void _sendComment() {
    final comment = _controller.text.trim();
    if (comment.isNotEmpty) {
      Provider.of<CommentProvider>(context, listen: false).addComment(comment);
      _controller.clear();
    }
  }

  void _deleteComment(int index) {
    Provider.of<CommentProvider>(context, listen: false).deleteComment(index);
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    final commentProvider = Provider.of<CommentProvider>(context);
    final bool isDark = myProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Column(
        children: [
          if (commentProvider.comments.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 357,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(3),
                    color: Theme.of(context).cardColor,
                    child: Text(
                      "viewers_comments_will_be_shown_here_tap_on_a_comment_to_show_it_on_screen"
                          .tr(),
                      style: GoogleFonts.inter(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 1, left: 1, right: 1),
            child: Row(
              children: [
                Transform.scale(
                  scaleX: 28 / 59,
                  scaleY: 13 / 34,
                  child: Switch(
                    value: myProvider.isOverlayEnabled,
                    onChanged: (value) {
                      myProvider.toggleOverlay(value);
                    },
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text("overlay".tr(), style: GoogleFonts.inter(fontSize: 14)),
              ],
            ),
          ),
          Expanded(
            child:
                commentProvider.comments.isEmpty
                    ? Center(
                      child: Text(
                        "no_comments".tr(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: commentProvider.comments.length,
                      itemBuilder: (context, index) {
                        final commentText = commentProvider.comments[index];
                        final isTapped = commentProvider.tappedComments
                            .contains(index);
                        final isShown =
                            commentProvider.shownCommentIndex == index;

                        final isStarred = commentProvider.isCommentStarred(
                          index,
                        );

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              commentProvider.toggleCommentTapped(index);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                isTapped
                                    ? buildCommentRow(
                                      index: index,
                                      comment: commentText,
                                      isShown: isShown,
                                      isStarred: isStarred,
                                      onShowHideTap:
                                          () => commentProvider
                                              .toggleCommentShown(index),
                                      onStarTap:
                                          () => commentProvider
                                              .toggleStarredComment(index),
                                      onDeleteTap: () => _deleteComment(index),
                                    )
                                    : Row(
                                      children: [
                                        const Icon(
                                          Icons.person_rounded,
                                          color: Color(0xFFBDBDBD),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            commentText,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xFF444444),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        );
                      },
                    ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:
                              isDark ? Colors.white : const Color(0xff5E5E66),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "comment".tr(),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: isDark ? Colors.white : const Color(0xff5E5E66),
                    ),
                    onPressed: _sendComment,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCommentRow({
    required int index,
    required String comment,
    required bool isShown,
    required bool isStarred,
    required VoidCallback onShowHideTap,
    required VoidCallback onStarTap,
    required VoidCallback onDeleteTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: SizedBox(
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
                        color: Colors.black87,
                      ),
                      onPressed: onStarTap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.black87,
                      ),
                      onPressed: onDeleteTap,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ],
            ),

            buildShowHideButton(isShown: isShown, onTap: onShowHideTap),
          ],
        ),
      ),
    );
  }

  Widget buildShowHideButton({
    required bool isShown,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isShown ? Icons.remove_circle_outline : Icons.add_circle_outline,
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
    );
  }
}
