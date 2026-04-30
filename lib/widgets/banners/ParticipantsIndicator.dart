import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/core/provider/my_provider.dart';

class ParticipantsIndicator extends StatefulWidget {
  final List<String> participants;

  const ParticipantsIndicator({
    super.key,
    required this.participants,
  });

  @override
  State<ParticipantsIndicator> createState() => _ParticipantsIndicatorState();
}

class _ParticipantsIndicatorState extends State<ParticipantsIndicator> {
  bool open = false;

  BoxDecoration _getDecoration(String themeType, Color color) {
    switch (themeType) {
      case 'minimal':
        return BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color),
          borderRadius: BorderRadius.zero,
        );

      case 'news':
        return BoxDecoration(
          color: color,
          borderRadius: BorderRadius.zero,
        );

      case 'bubble':
      default:
        return BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyProvider>();
    final themeType = provider.selectedTheme;
    final color = provider.primaryColor;

    final decoration = _getDecoration(themeType, color);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => setState(() => open = !open),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (themeType == 'minimal')
                    Container(
                      width: 8,
                      height: 32,
                      color: color,
                    ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: decoration,
                    child: Text(
                      "${widget.participants.length} Person",
                      style: TextStyle(
                        color: themeType == 'minimal'
                            ? Colors.black
                            : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // 🔥 OVERLAY (بيغطي Status من غير ما يزقه)
        if (open)
          Positioned(
            top: 45,
            left: 0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeType == 'minimal'
                      ? Colors.white
                      : color.withOpacity(0.15),
                  borderRadius: BorderRadius.zero,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.participants
                      .map(
                        (name) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text("• $name"),
                    ),
                  )
                      .toList(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// -------------------- STATUS INDICATOR --------------------

class StatusIndicator extends StatefulWidget {
  final bool initialStatus;

  const StatusIndicator({
    super.key,
    required this.initialStatus,
  });

  @override
  State<StatusIndicator> createState() => _StatusIndicatorState();
}

class _StatusIndicatorState extends State<StatusIndicator> {
  late bool isWorking;

  @override
  void initState() {
    super.initState();
    isWorking = widget.initialStatus;
  }

  BoxDecoration _getDecoration(String themeType, Color color) {
    switch (themeType) {
      case 'minimal':
        return BoxDecoration(
          color: Colors.white,
          border: Border.all(color: color),
          borderRadius: BorderRadius.zero,
        );

      case 'news':
        return BoxDecoration(
          color: color,
          borderRadius: BorderRadius.zero,
        );

      case 'bubble':
      default:
        return BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyProvider>();
    final themeType = provider.selectedTheme;
    final color = provider.primaryColor;

    return GestureDetector(
      onTap: () => setState(() => isWorking = !isWorking),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (themeType == 'minimal')
            Container(
              width: 8,
              height: 32,
              color: color,
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: _getDecoration(themeType, color),
            child: Text(
              isWorking ? "online" : "offline",
              style: TextStyle(
                color: themeType == 'minimal'
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}