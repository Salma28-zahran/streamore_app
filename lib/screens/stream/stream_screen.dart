import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamore_app/screens/stream/drawer/main_drawer.dart';
import 'package:streamore_app/screens/tabs/banners_tab.dart';
import 'package:streamore_app/screens/tabs/brand_tab.dart';
import 'package:streamore_app/screens/tabs/comments_tab.dart';
import '../../my_provider.dart';

class StreamScreen extends StatelessWidget {
  static const String routeName = "/stream";

  const StreamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyProvider>(context);
    bool hasNotification = false;

    return Scaffold(
      drawer: MainDrawer(),
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
            padding: const EdgeInsets.only(right: 10),
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
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Theme.of(context).dividerColor,
            thickness: 1,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/images/profile4.jpeg",
                    width: 377,
                    height: 207,
                    fit: BoxFit.cover,
                  ),

                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: _buildOverlay(myprovider),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25, top: 8),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(190)),
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Color(0xff212b49)
                        : Color(0xff5E5E66),
                  ),
                  child: Icon(
                    Icons.mic,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(190)),
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Color(0xff212b49)
                        : Color(0xff5E5E66),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(190)),
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Color(0xff212b49)
                        : Color(0xff5E5E66),
                  ),
                  child: Icon(
                    Icons.cast_sharp,
                    color: Theme.of(context).iconTheme.color,
                    size: 32,
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(190)),
                    color: myprovider.themeMode == ThemeMode.dark
                        ? Color(0xff212b49)
                        : Color(0xff5E5E66),
                  ),
                  child: Icon(
                    Icons.person_add,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/settings_icon");
                  },
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(190)),
                      color: myprovider.themeMode == ThemeMode.dark
                          ? Color(0xff212b49)
                          : Color(0xff5E5E66),
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Expanded(
                child: Container(
                  width: 378,
                  //height: 808,
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
                        offset: Offset(0, 3),
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
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          unselectedLabelStyle: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: [
                            Tab(text: "Brand"),
                            Tab(text: "Banners"),
                            Tab(text: "Comments"),
                          ],
                        ),
                        Expanded(
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
          ),
        ],
      ),
    );
  }
}
Widget _buildOverlay(MyProvider provider) {
  final theme = provider.selectedTheme;
  final color = provider.primaryColor;

  switch (theme) {
    case 'Minimal':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 23,
              color: color,
            ),
           // SizedBox(width: 4),
            Container(
              width: 67,
              height: 23,
              color: Colors.white,
              child: Center(
                child: Text(
                  'John Doe',
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

    case 'Bubble':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 73,
          height: 22,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              'John Doe',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );

    case 'News':
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 76,
          height: 21,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Center(
            child: Text(
              'John Doe',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );

    default:
      return SizedBox.shrink();
  }
}


