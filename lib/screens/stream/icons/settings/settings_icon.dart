import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/provider/my_provider.dart' show MyProvider;
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/widgets/app_bar/custom_appbar.dart';


class SettingsIcon extends StatefulWidget {
  static const routeName = "/settings_icon";

  const SettingsIcon({super.key});

  @override
  State<SettingsIcon> createState() => _SettingsIconState();
}

class _SettingsIconState extends State<SettingsIcon> {
  int selectedIndex = -1;
  bool hasNotification = false;

  final List<Map<String, dynamic>> settingsItems = [
    {'icon': Icons.settings_outlined, 'text': 'general'.tr()},
    {'icon': Icons.videocam_outlined, 'text': 'camera'.tr()},
    {'icon': Icons.mic_none, 'text': 'audio'.tr()},
    {'icon': FontAwesomeIcons.images, 'text': 'virtual_background'.tr()},
    {'icon': Icons.person_pin_sharp, 'text': 'layouts'.tr()},
  ];

  void handleTap(String title, int index) {
    setState(() {
      selectedIndex = index;
    });

    if (title == "general".tr()) {
      Navigator.pushNamed(context, '/general');
    } else if (title == "camera".tr()) {
      Navigator.pushNamed(context, '/camera');
    } else if (title == "audio".tr()) {
      Navigator.pushNamed(context, '/audio');
    } else if (title == "virtual_background".tr()) {
      Navigator.pushNamed(context, '/back');
    } else if (title == "layouts".tr()) {
      Navigator.pushNamed(context, '/lay');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyProvider>(context, listen: false);

    return WillPopScope(
      onWillPop: () async {
        if (myprovider.orientation == "landscape") {
          Navigator.pushReplacementNamed(context, "/full_image");
        } else {
          Navigator.pop(context);
        }
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(hasNotification: false),

        drawer: MainDrawer(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: myprovider.themeMode == ThemeMode.dark
                          ? Colors.white
                          : Colors.black,
                      size: 16,
                    ),
                    onPressed: () {
                      if (myprovider.orientation == "landscape") {
                        Navigator.pushReplacementNamed(context, "/full_image");
                      } else {
                        Navigator.pushReplacementNamed(context, "/stream");
                      }
                    },
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 17),
                    child: Text(
                      'settings'.tr(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: myprovider.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Theme.of(context).dividerColor,
              thickness: 0.5,
              height: 1,
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: settingsItems.length,
                itemBuilder: (context, index) {
                  final item = settingsItems[index];
                  final icon = item['icon'];
                  final title = item['text'];
                  final isSelected = selectedIndex == index;

                  return InkWell(
                    onTap: () => handleTap(title, index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF4D8EFF) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            icon,
                            color: isSelected
                                ? Theme.of(context).tabBarTheme.labelColor
                                : Theme.of(context).tabBarTheme.unselectedLabelColor,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: isSelected
                                  ? Theme.of(context).tabBarTheme.labelColor
                                  : Theme.of(context).tabBarTheme.unselectedLabelColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }}