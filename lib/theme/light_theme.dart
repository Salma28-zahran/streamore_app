import 'package:flutter/material.dart';
import 'package:streamore_app/theme/theme.dart';

class LightTheme extends BaseTheme{
  @override
  Color get backgroundColor => Color(0xffFFFFFF);

  @override
  Color get primaryColor => Color(0xff1865E8);

  @override
  Color get textColor => Color(0xff5E5E66);

  @override
  ThemeData get themeData => ThemeData(
      colorScheme: ColorScheme.light(
        primary: Color(0xff1865E8),
      ),
    scaffoldBackgroundColor: Color(0xffFFFFFF),
      primaryColor: Color(0xff1865E8),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
       foregroundColor: Colors.black,
      elevation: 0,
    ),
    textTheme: const TextTheme(
        //Color(0xff5E5E66)
      bodyLarge: TextStyle(color: Color(0xff5E5E66)),

    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    cardColor: const Color(0xffFFFFFF),
    dividerColor: Colors.black,

    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xff5E5E66),
    ),





  );

}