import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';

class LayoutScreen extends StatefulWidget {
  static const routeName = "/lay";

  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int selectedIndex = 1;

  final List<LayoutOption> layouts = [
    LayoutOption(titleKey: 'default'),
    LayoutOption(titleKey: 'cropped_layout'),
    LayoutOption(titleKey: 'spotlight_layout'),
    LayoutOption(titleKey: 'screen_layout'),
    LayoutOption(titleKey: 'picture_in_picture'),
    LayoutOption(titleKey: 'news_layout'),
    LayoutOption(titleKey: 'cinema_layout'),
  ];

  void selectLayout(int index) => setState(() => selectedIndex = index);

  String getImageName(String key, bool isSelected) {
    final prefix = key == 'default' ? 'defaultt' : key; 
    return isSelected ? '${prefix}_selected.png' : '$prefix.png';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      
      
      appBar: CustomAppBar(hasNotification: false),

      drawer:  MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(textColor),
            const SizedBox(height: 12),
            Divider(color: theme.dividerColor, thickness: 0.5),
            const SizedBox(height: 12),
            _buildGridLayout(textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 16, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 4),
        Text(
          "layout".tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGridLayout(Color textColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final layoutOrder = [
      0, 1,
      3, 2,
      5, 4,
      6,
    ];

    return Column(
      children: [
        for (int row = 0; row < 3; row++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int col = 0; col < 2; col++)
                  SizedBox(
                    width: (MediaQuery.of(context).size.width - 48) / 2,
                    child: _buildGridItem(
                      layoutOrder[row * 2 + col],
                      isDark,
                      textColor,
                    ),
                  ),
              ],
            ),
          ),
        Center(
          child: SizedBox(
            width: (MediaQuery.of(context).size.width - 48) / 2,
            child: _buildGridItem(layoutOrder[6], isDark, textColor),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(int index, bool isDark, Color textColor) {
    final theme = Theme.of(context);
    final layout = layouts[index];
    final isSelected = index == selectedIndex;
    final imagePath =
        'assets/images/${getImageName(layout.titleKey, isSelected)}';

    return GestureDetector(
      onTap: () => selectLayout(index),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: isSelected
              ? Border.all(
                  color: isDark ? Colors.white : theme.primaryColor,
                  width: 2,
                )
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 84,
              width: 84,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.image_not_supported,
                size: 48,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              layout.titleKey.tr(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LayoutOption {
  final String titleKey;
  LayoutOption({required this.titleKey});
}
