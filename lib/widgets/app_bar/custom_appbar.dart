import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasNotification;

  const CustomAppBar({
    super.key,
    this.hasNotification = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(95);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 70,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 2,
        ),
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? const Color(0xff03133D)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),

              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon:  Icon(
                    Icons.menu,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                    size: 28,
                  ),
                ),
              ),

              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/images/app_name2.png",
                    height: media.height * 0.03,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 14),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      FontAwesomeIcons.bell,
                      color: Theme.of(context).colorScheme.primary,
                      size: 22,
                    ),
                    if (hasNotification)
                      const Positioned(
                        right: -2,
                        top: -2,
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}