import 'package:flutter/material.dart';
import 'package:streamore_app/my_provider.dart';

Widget circleIcon({
  required BuildContext context,
  required bool isOn,
  required IconData onIcon,
  required IconData offIcon,
  required double size,
  required bool isSmall,
  required ThemeMode currentMode,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size),
      color: isOn
          ? (currentMode == ThemeMode.dark
          ? const Color(0xff212b49)
          : const Color(0xff5E5E66))
          : const Color(0xff350808),
    ),
    child: Icon(
      isOn ? onIcon : offIcon,
      color: isOn ? Theme.of(context).iconTheme.color : Colors.red[400],
      size: isSmall ? 20 : 24,
    ),
  );
}

Widget buildIcon({
  required BuildContext context,
  required IconData icon,
  required double size,
  required MyProvider myprovider,
  required bool isSmall,
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap ??
        (icon == Icons.settings
            ? () => Navigator.pushNamed(context, "/settings_icon")
            : null),
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
