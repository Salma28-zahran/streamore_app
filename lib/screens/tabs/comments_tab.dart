import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentsTab extends StatefulWidget {
  static const String routeName = "/comments";

  const CommentsTab({super.key});

  @override
  State<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends State<CommentsTab> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _comments = [];

  bool _isOverlayEnabled = false;

  void _sendComment() {
    String comment = _controller.text.trim();

    if (comment.isNotEmpty) {
      setState(() {
        _comments.add(comment);
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (_comments.isEmpty)
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
                      "Viewers’ comments will be shown here. Tap on a comment to show it on screen",
                      style: GoogleFonts.inter(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),


          Padding(
            padding: const EdgeInsets.only(top: 1, left: 1, right: 1),
            child:
            Row(
              children: [
                Transform.scale(
                  scaleX: 28 / 59,
                  scaleY: 13 / 34,
                  child: Switch(
                    value: _isOverlayEnabled,
                    onChanged: (value) {
                      setState(() {
                        _isOverlayEnabled = value;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.primary,

                  ),
                ),

                Text(
                  "Overlay",
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ],
            ),
          ),

          Expanded(
            child: _comments.isEmpty
                ? Center(
              child: Text(
                "no comments",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.person,
                        color: Color(0xff5E5E66),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _comments[index],
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ),
                    ],
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
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Comment...",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendComment(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xff5E5E66)),
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
