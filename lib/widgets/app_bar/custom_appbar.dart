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
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      title: Image.asset("assets/images/app_name.png"),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Stack(
            children: [
              Icon(
                FontAwesomeIcons.bell,
                color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
