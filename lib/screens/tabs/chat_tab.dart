import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../my_provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(text.trim());
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = Provider.of<MyProvider>(context);
    final bool isDark = myProvider.themeMode == ThemeMode.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Column(
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: _messages.isEmpty
                ?  Center(
              child: Text(
                "no_message".tr(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) => Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _messages[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),



          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Divider
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 1,
              ),


              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark ? Theme.of(context).scaffoldBackgroundColor : Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [

                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration:  InputDecoration(
                          hintText: "messages".tr(),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 14, horizontal: 12),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),

                    IconButton(
                      icon:  Icon(Icons.send,
                          color:  isDark ? Colors.white : Color(0xff5E5E66),
                      ),
                      onPressed: () => _sendMessage(_controller.text),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
