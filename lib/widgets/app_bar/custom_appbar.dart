import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hasNotification;

  const CustomAppBar({
    super.key,
    this.hasNotification = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Image.asset(
        "assets/images/app_name2.png",
        height: media.height * 0.05,
        width: media.width * 0.46,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: media.width * 0.025,
          ),
          child: Stack(
            children: [
              Icon(
                FontAwesomeIcons.bell,
                color: Theme.of(context).colorScheme.primary,
                size: media.width * 0.06,
              ),
              if (hasNotification)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: media.width * 0.02,
                    height: media.width * 0.02,
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
        preferredSize: Size.fromHeight(media.height * 0.001),
        child: Divider(
          color: Theme.of(context).dividerColor,
          thickness: media.height * 0.0006,
          height: media.height * 0.001,
        ),
      ),
    );
  }
}