import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "content_sharing".tr(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.appBarTheme.foregroundColor,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: theme.iconTheme.color),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(
            thickness: 1.2,
            height: 20,
            color: Color(0xFFC8C8C8), // Light gray
          ),
          const SizedBox(height: 10),
          _buildOptionButton(
            context,
            imagePath: 'assets/images/share.png',
            textKey: "share_screen",
          ),
          _buildOptionButton(
            context,
            imagePath: 'assets/images/image.png',
            textKey: "image",
          ),
          _buildOptionButton(
            context,
            imagePath: 'assets/images/video.png',
            textKey: "video",
          ),
          _buildOptionButton(
            context,
            imagePath: 'assets/images/presentaion.png',
            textKey: "presentation_pdf",
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, {
    required String imagePath,
    required String textKey,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        final text = textKey.tr();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("selected_message".tr(namedArgs: {'option': text}))),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 26,
              height: 26,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 14),
            Text(
              textKey.tr(),
              style: TextStyle(
                fontSize: 16,
                color: theme.appBarTheme.foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
