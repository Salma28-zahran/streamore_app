import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:streamore_app/features/tabs/banners/banners_tab.dart';
import 'package:streamore_app/features/tabs/brand/brand_tab.dart';
import 'package:streamore_app/features/tabs/chat/presentaion/views/chat_tab.dart';
import 'package:streamore_app/features/tabs/comment/comments_tab.dart';
import 'package:streamore_app/features/tabs/people/people_tab.dart';

class ExpandToolsWidget extends StatefulWidget {
  const ExpandToolsWidget({super.key});

  @override
  State<ExpandToolsWidget> createState() => _ExpandToolsWidgetState();
}

class _ExpandToolsWidgetState extends State<ExpandToolsWidget>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  Widget? selectedContent;
  String? selectedTitle;

  final List<_ToolItem> items = [
    _ToolItem(Icons.palette_outlined, "Brand"),
    _ToolItem(Icons.crop_landscape_outlined, "Banners"),
    _ToolItem(Icons.comment_outlined, "Comments"),
    _ToolItem(Icons.chat_bubble_outline, "Chat"),
    _ToolItem(Icons.people_outline, "People"),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
            if (selectedContent != null)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                left: 12,
                right: 12,
                bottom: 70,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: MediaQuery.of(context).size.height * .55,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.15),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedContent = null;
                                    isExpanded = true;
                                  });
                                },
                                borderRadius: BorderRadius.circular(20),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 22,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 4),

                              Text(
                                selectedTitle ?? '',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Divider(
                          height: 1,
                          color: Colors.grey.withOpacity(.2),
                        ),

                        Expanded(
                          child: selectedContent!,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          /// EXPANDABLE PANEL
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            left: 12,
            right: 12,
            bottom: isExpanded ? 70 : 40,
            child: IgnorePointer(
              ignoring: !isExpanded,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: isExpanded ? 1 : 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 22,
                      sigmaY: 22,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: isDark
                            ? const Color(0xff101A3B).withOpacity(.55)
                            : Colors.white,
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 4,
                        runSpacing: 8,
                        children: items.map((item) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = false;
                                selectedTitle = item.title;

                                switch (item.title) {
                                  case "Brand":
                                    selectedContent = const BrandTab();
                                    break;

                                  case "Banners":
                                    selectedContent = const BannersTab();
                                    break;

                                  case "Comments":
                                    selectedContent = const CommentsTab();
                                    break;

                                  case "Chat":
                                    selectedContent = const ChatTab();
                                    break;

                                  case "People":
                                    selectedContent = const PeopleTab();
                                    break;
                                }
                              });
                            },
                            child: SizedBox(
                              width: 78,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isDark
                                          ? const Color(0xff1A2347)
                                          : const Color(0xffF4F5F7),
                                    ),
                                    child: Icon(
                                      item.icon,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(item.title),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// BOTTOM BUTTON
          /// BOTTOM BUTTON
          Positioned(
            left: 12,
            right: 12,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 18,
                    sigmaY: 18,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: isDark
                          ? const Color(0xff0A1432).withOpacity(0.35)
                          : Colors.white,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.grey.withOpacity(0.12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? const Color(0xff3D7BFF).withOpacity(0.12)
                              : Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.keyboard_arrow_up_rounded,
                          size: 40,
                          color: isDark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToolItem {
  final IconData icon;
  final String title;

  _ToolItem(this.icon, this.title);
}