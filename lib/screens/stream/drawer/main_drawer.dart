import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:streamore_app/my_provider.dart';

class MainDrawer extends StatefulWidget {
  static const String routeName = "/drawer";
  MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  int selectedIndex = 0;

  Widget buildDrawerItem(int index, IconData icon, String title) {
    bool isSelected = index == selectedIndex;
    var myprovider = Provider.of<MyProvider>(context);

    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });

        if (title == "Theme") {
          context.read<MyProvider>().changeTheme();
        } else if (title == "Home") {
          Navigator.pushNamed(context, "/stream");
        } else if (title == "Destination") {
          Navigator.pushNamed(context, '/destination');
        } else if (title == "Members") {
          Navigator.pushNamed(context, '/members');
        } else if (title == "Library") {
          Navigator.pushNamed(context, '/library');
        } else if (title == "Referrals") {
          Navigator.pushNamed(context, '/referrals');
        } else if (title == "Settings") {
          Navigator.pushNamed(context, '/Settings');
        } else if (title == "Signout") {
          Navigator.pushNamed(context, '/signin');
        }
      },
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
  }

  @override
  Widget build(BuildContext context) {
    var myprovider = Provider.of<MyProvider>(context);

    IconData themeIcon =
    myprovider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode;

    return Drawer(
      backgroundColor: Theme.of(context).cardColor,
      width: 348,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Theme.of(context).cardColor,
              padding: const EdgeInsets.all(16),
              alignment: Alignment.bottomLeft,
              child: Text(
                "Streamore",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Image.asset(
              "assets/images/my_acc.png",
              width: 344,
              height: 44,
            ),
            const SizedBox(height: 10),
            Divider(
              thickness: 1,
              color: Theme.of(context).dividerColor,
              indent: 50,
              endIndent: 50,
            ),
            const SizedBox(height: 16),

            // Main Items
            buildDrawerItem(0, Icons.grid_view, "Home"),
            buildDrawerItem(1, Icons.share, "Destination"),
            buildDrawerItem(2, Icons.group, "Members"),
            buildDrawerItem(3, Icons.video_library, "Library"),
            buildDrawerItem(5, FontAwesomeIcons.gift, "Referrals"),
            buildDrawerItem(6, Icons.settings_outlined, "Settings"),

            const SizedBox(height: 198),

            Padding(
              padding: const EdgeInsets.only(left: 39),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/verify1');
                    },
                    child: Text(
                      "Contact Us",
                      style: GoogleFonts.montserrat(
                        color: myprovider.themeMode == ThemeMode.dark
                            ?  Colors.white
                            :  const Color(0xffAFAFAF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 45),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/verify1');
                    },
                    child: Text(
                      "Help Center",
                      style: GoogleFonts.montserrat(
                        color: myprovider.themeMode == ThemeMode.dark
                            ?  Colors.white
                            :  const Color(0xffAFAFAF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),

            Padding(
              padding: const EdgeInsets.only(left: 39),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/verify1');
                    },
                    child: Text(
                      "News",
                      style: GoogleFonts.montserrat(
                        color: myprovider.themeMode == ThemeMode.dark
                            ?  Colors.white
                            :  const Color(0xffAFAFAF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 80),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/verify1');
                    },
                    child: Text(
                      "Our Policies",
                      style: GoogleFonts.montserrat(
                        color: myprovider.themeMode == ThemeMode.dark
                            ?  Colors.white
                            : const Color(0xffAFAFAF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
