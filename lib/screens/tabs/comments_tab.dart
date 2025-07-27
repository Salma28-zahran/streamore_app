import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../my_provider.dart';
import 'package:streamore_app/my_provider.dart';

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
      Provider.of<MyProvider>(context, listen: false).addComment(comment);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    final bool isDark = myProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: Column(
        children: [
          if (myProvider.comments.isEmpty)
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
                      "viewers_comments_will_be_shown_here_tap_on_a_comment_to_show_it_on_screen".tr(),
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
                Text(
                  "overlay".tr(),
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: myProvider.comments.isEmpty
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
              padding: const EdgeInsets.all(12),
              itemCount: myProvider.comments.length,
              itemBuilder: (context, index) {
                final isTapped = myProvider.tappedComments.contains(index);
                final isShown = myProvider.shownComments.contains(index);
                final isStarred = myProvider.starredComments.contains(index);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      myProvider.toggleCommentTapped(index);
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person, color: Color(0xff5E5E66)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Opacity(
                                  opacity: isTapped ? 0.4 : 1.0,
                                  child: Text(
                                    myProvider.comments[index],
                                    style: GoogleFonts.inter(fontSize: 14),
                                  ),
                                ),
                              ),
                              if (isTapped)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () =>
                                          myProvider.toggleCommentShown(index),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                  const Color(0xFF666666),
                                                  width: 1.5),
                                            ),
                                            child: Icon(
                                              isShown
                                                  ? Icons.remove
                                                  : Icons.add,
                                              size: 16,
                                              color: const Color(0xFF666666),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            isShown
                                                ? "hide".tr()
                                                : "show".tr(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF4F4F4F),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () =>
                                          myProvider.toggleCommentStarred(
                                              index),
                                      child: Icon(
                                        isStarred
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 22,
                                        color: const Color(0xFF666666),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    GestureDetector(
                                      onTap: () =>
                                          myProvider.deleteComment(index),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 22,
                                        color: Color(0xFFBDBDBD),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
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
                    icon: Icon(Icons.send,
                        color:
                        isDark ? Colors.white : const Color(0xff5E5E66)),
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
}
