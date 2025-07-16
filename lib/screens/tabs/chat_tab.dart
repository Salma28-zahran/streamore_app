import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:streamore_app/my_provider.dart';
import 'package:provider/provider.dart';


class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
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

    return Scaffold(
      body: Column(
        children: [







          Expanded(
            child: myProvider.comments.isEmpty
                ? Center(
              child: Text(
                "no Messages",
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
                          myProvider.comments[index],
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
                        decoration: InputDecoration(
                          hintText: "Message...",
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
    );;
  }
}
