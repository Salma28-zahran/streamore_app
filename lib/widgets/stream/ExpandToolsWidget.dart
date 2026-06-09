import 'dart:ui';
import 'package:flutter/material.dart';

class ExpandToolsWidget extends StatefulWidget {
  const ExpandToolsWidget({super.key});

  @override
  State<ExpandToolsWidget> createState() => _ExpandToolsWidgetState();
}

class _ExpandToolsWidgetState extends State<ExpandToolsWidget>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;

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
                child: AnimatedSlide(
                  duration: const Duration(milliseconds: 350),
                  offset:
                  isExpanded ? Offset.zero : const Offset(0, .15),
                  curve: Curves.easeOut,
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 350),
                    scale: isExpanded ? 1 : .9,
                    curve: Curves.easeOutBack,
                    alignment: Alignment.bottomCenter,
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
                            borderRadius:
                            BorderRadius.circular(24),
                            color: isDark
                                ? const Color(0xff101A3B)
                                .withOpacity(.55)
                                : Colors.white,
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(.08)
                                  : Colors.grey.withOpacity(.12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.12),
                                blurRadius: 25,
                                spreadRadius: 1,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Wrap(
                            alignment:
                            WrapAlignment.spaceEvenly,
                            spacing: 4,
                            runSpacing: 8,
                            children: items.map((item) {
                              return GestureDetector(
                                onTap: () {},
                                child: SizedBox(
                                  width: 78,
                                  child: Column(
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      AnimatedContainer(
                                        duration:
                                        const Duration(
                                            milliseconds:
                                            250),
                                        width: 56,
                                        height: 56,
                                        decoration:
                                        BoxDecoration(
                                          shape:
                                          BoxShape.circle,
                                          color: isDark
                                              ? const Color(
                                              0xff1A2347)
                                              : const Color(
                                              0xffF4F5F7),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors
                                                  .black
                                                  .withOpacity(
                                                  .06),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          item.icon,
                                          size: 25,
                                          color: isDark
                                              ? Colors.white
                                              : Colors
                                              .black87,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 4),
                                      Text(
                                        item.title,
                                        textAlign:
                                        TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
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