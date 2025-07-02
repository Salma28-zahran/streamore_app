import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/my_provider.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';

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
  LayoutOption(titleKey: 'group_layout'),
  LayoutOption(titleKey: 'spotlight_layout'),
  LayoutOption(titleKey: 'screen_layout'),
  LayoutOption(titleKey: 'picture_in_picture'),
  LayoutOption(titleKey: 'news_layout'),
  LayoutOption(titleKey: 'cinema_layout'),
];


  void selectLayout(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  int getCrossAxisCount(double width) {
    if (width < 200) return 1;
    if (width < 800) return 2;
    return 3;
  }

  String getImageName(String key) {
  if (key == 'default') return 'defaultt.png';
  if (key == 'picture_in_picture') return 'picture_in_picture.png';
  return key + '.png';
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final myprovider = Provider.of<MyProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = myprovider.themeMode == ThemeMode.dark;
    final baseTextColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text("streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: theme.appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(
              FontAwesomeIcons.bell,
              color: theme.primaryColorDark,
              size: 22,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: theme.dividerColor, thickness: 0.5, height: 1),
        ),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, baseTextColor),
            const SizedBox(height: 12),
            Divider(color: theme.dividerColor, thickness: 0.5),
            const SizedBox(height: 12),
            Flexible(child: _buildGrid(theme, baseTextColor, screenWidth)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color baseTextColor) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 16, color: baseTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        const SizedBox(width: 4),
        Text('layout'.tr(),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: baseTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid(ThemeData theme, Color baseTextColor, double screenWidth) {
    return GridView.builder(
      itemCount: layouts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: getCrossAxisCount(screenWidth),
        crossAxisSpacing: 16,
        mainAxisSpacing: 0,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        final layout = layouts[index];
        final isSelected = index == selectedIndex;
        final imageName = getImageName(layout.titleKey);
        final imagePath = 'assets/images/$imageName';

        return GestureDetector(
          onTap: () => selectLayout(index),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              border:
                  isSelected
                      ? Border.all(color: theme.primaryColor, width: 2)
                      : null,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    imagePath,
                    height: 84,
                    width: 84,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      );
                    },
                  ),
              
                  const SizedBox(height: 8),
                  Text(
                    layout.titleKey.tr(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: baseTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}


class LayoutOption {
  final String titleKey;
  LayoutOption({required this.titleKey});
}
