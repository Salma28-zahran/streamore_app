import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:streamore_app/core/provider/my_provider.dart';
import 'package:streamore_app/features/tabs/chat/bloc/chat_cubit.dart';
import 'package:streamore_app/features/tabs/chat/bloc/chat_states.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(BuildContext context, String text) {
    if (text.trim().isEmpty) {
      print("⚠️ محاولة إرسال رسالة فاضية");
      return;
    }

    print("📤 محاولة إرسال رسالة: $text");
    final chatCubit = context.read<ChatCubit>();

    // ➕ إضافة الرسالة محلياً قبل الإرسال (اختياري)
    chatCubit.addLocalMessage({
      "type": "message",
      "sender_id": "123",
      "content": text.trim(),
    });

    _controller.clear();
    print("✅ الرسالة اتمسحت من التكست فيلد");

    // 🔹 إرسال الرسالة فعلياً عبر WebSocket
    chatCubit.sendMessage(senderId: "123", content: text.trim());
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

          /// 🔹 الرسائل
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                print("🌀 BlocBuilder بيشتغل. الحالة الحالية: $state");

                List<Map<String, dynamic>> messages = [];
                if (state is ChatMessageReceived) {
                  messages = state.messages;
                  print("📩 عدد الرسائل المستلمة: ${messages.length}");
                }

                if (messages.isEmpty) {
                  print("ℹ️ مفيش رسائل في الليست");
                  return Center(
                    child: Text(
                      "no_message".tr(),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    print("💬 رسالة [${index + 1}]: ${msg["content"]}");
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          msg["content"].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// 🔹 إدخال الرسائل
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 1,
              ),
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Theme.of(context).scaffoldBackgroundColor
                      : const Color(0xffEFEFEF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "messages".tr(),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                        ),
                        onSubmitted: (text) {
                          print("⏎ المستخدم ضغط Enter: $text");
                          _sendMessage(context, text);
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: isDark ? Colors.white : const Color(0xff5E5E66),
                      ),
                      onPressed: () {
                        print("👆 المستخدم ضغط زر الإرسال");
                        _sendMessage(context, _controller.text);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
