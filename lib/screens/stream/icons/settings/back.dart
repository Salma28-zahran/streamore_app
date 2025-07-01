import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/my_provider.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:provider/provider.dart';

class Back extends StatefulWidget {
  static const routeName = "/back";

  const Back({super.key});

  @override
  State<Back> createState() => _BackState();
}

class _BackState extends State<Back> {
  bool _isOverlayEnabled = false;

  @override
  Widget build(BuildContext context) {
    bool hasNotification = false;
    var myprovider = Provider.of<MyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10,left: 10),
            child: Stack(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).primaryColorDark,
                  size: 24,
                ),
                if (hasNotification)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            height: 1,
          ),
        ),
      ),
      drawer: MainDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back button and title
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: myprovider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black,
                  size: 16,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 17),
                child: Text(
                  'virtual_background'.tr(),
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
          Divider(
            color: Theme.of(context).dividerColor,
            thickness: 0.5,
            height: 1,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 22),
                child: Container(
                  width: 385,
                  height: 230,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    "assets/images/camera.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "for_best_performance_we_recommend_using_a_green_screen".tr(),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: myprovider.themeMode == ThemeMode.dark
                      ? Colors.white
                      : const Color(0xff5E5E66),
                ),
              )
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Transform.scale(
                scaleX: 28 / 59,
                scaleY: 13 / 34,
                child: Switch(
                  value: _isOverlayEnabled,
                  onChanged: (value) {
                    setState(() {
                      _isOverlayEnabled = value;
                    });
                  },
                ),
              ),
              Text(
                "green_screen_effect".tr(),
                style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 14, bottom: 10, top: 10,right: 14),
            child: Text(
              "virtual_background".tr(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(height:15 ,),

          Padding(
            padding: const EdgeInsets.only(left: 14,right: 14),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildBackgroundBox(type: 'none'),
                  const SizedBox(width: 10),
                  _buildBackgroundBox(type: 'image'),
                  const SizedBox(width: 10),
                  _buildBackgroundBox(type: 'image'),
                  const SizedBox(width: 10),
                  _buildBackgroundBox(type: 'add'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundBox({required String type}) {
    double size = 70;

    if (type == 'none') {
      return Container(
        width: 74,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, color: Colors.grey),
            const SizedBox(height: 4),
            Text("None", style: GoogleFonts.poppins(fontSize: 10)),
          ],
        ),
      );
    } else if (type == 'image') {
      return Container(
        width: 74,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(2),
        ),
      );
    } else {
      return Container(
        width: 74,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(2),
        ),
        child: Icon(Icons.add, color: Colors.grey),
      );
    }
  }
}
