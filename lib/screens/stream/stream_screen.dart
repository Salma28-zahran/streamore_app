import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/screens/tabs/banners_tab.dart';
import 'package:streamore_app/screens/tabs/brand_tab.dart';
import 'package:streamore_app/screens/tabs/comments_tab.dart';
import '../../my_provider.dart';
import 'package:streamore_app/widgets/overlay_style.dart';


class StreamScreen extends StatelessWidget {
  static const String routeName = "/stream";

  const StreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyProvider>(context);
    bool hasNotification = false;
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 400;
    final double iconSize = isSmall ? 44 : 54;
    final double profileImageWidth = size.width * 0.9425;
    final double profileImageHeight = size.height * 0.28;

    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Streamore",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: isSmall ? 18 : 22,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: isSmall ? 6 : 10),
            child: Stack(
              children: [
                Icon(
                  FontAwesomeIcons.bell,
                  color: Theme.of(context).primaryColorDark,
                  size: isSmall ? 20 : 24,
                ),
                if (hasNotification)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
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
            thickness: 1,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Image.asset(
                        "assets/images/profile4.png",
                        width: profileImageWidth,
                        height: profileImageHeight,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: buildOverlay(myprovider)
                      ,
                    ),

                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.only(left: size.width * 0.08, top: 8,right:  size.width * 0.04),
            child: Row(
              children: [
                for (var icon in [
                  Icons.mic,
                  Icons.camera_alt_rounded,
                  Icons.cast_sharp,
                  Icons.person_add,
                ])
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.04,),
                    child: Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(190),
                        color: myprovider.themeMode == ThemeMode.dark
                            ? const Color(0xff212b49)
                            : const Color(0xff5E5E66),
                      ),
                      child: Icon(
                        icon,
                        color: Theme.of(context).iconTheme.color,
                        size: isSmall ? 20 : 24,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/settings_icon"),
                    child: Container(
                      width: iconSize,
                      height: iconSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(190),
                        color: myprovider.themeMode == ThemeMode.dark
                            ? const Color(0xff212b49)
                            : const Color(0xff5E5E66),
                      ),
                      child: Icon(
                        Icons.settings,
                        color: Theme.of(context).iconTheme.color,
                        size: isSmall ? 20 : 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.015),
              child: Container(
                width: profileImageWidth,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.9),
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Colors.blue,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Colors.blue,
                        labelStyle: GoogleFonts.inter(
                          fontSize: isSmall ? 10 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                        unselectedLabelStyle: GoogleFonts.inter(
                          fontSize: isSmall ? 10 : 12,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs:  [
                          Tab(text: "brand".tr()),
                          Tab(text: "banners".tr()),
                          Tab(text: "comments".tr()),
                        ],
                      ),
                      const Expanded(
                        child: TabBarView(
                          children: [
                            BrandTab(),
                            BannersTab(),
                            CommentsTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildIcon(IconData icon, double size, BuildContext context, MyProvider myprovider, bool isSmall) {
    return GestureDetector(
      onTap: icon == Icons.settings
          ? () => Navigator.pushNamed(context, "/settings_icon")
          : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(190),
          color: myprovider.themeMode == ThemeMode.dark
              ? const Color(0xff212b49)
              : const Color(0xff5E5E66),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).iconTheme.color,
          size: isSmall ? 20 : 24,
        ),
      ),
    );
  }

}

