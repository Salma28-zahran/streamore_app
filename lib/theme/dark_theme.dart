import 'package:flutter/material.dart';
import 'package:streamore_app/theme/theme.dart';

class DarkTheme extends BaseTheme{
  @override
  Color get backgroundColor => Color(0xff24334A);

  @override
  Color get primaryColor => Color(0xff1865E8);

  @override
  Color get textColor => const Color(0xFFE5EAF3);

  @override
  ThemeData get themeData => ThemeData(
  colorScheme: ColorScheme.dark(
  primary: Color(0xff1865E8),),
    scaffoldBackgroundColor: Color(0xff0D142A),
    textTheme:  TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE5EAF3)),
      bodyMedium: TextStyle(color: Color(0xFFE5EAF3)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff0D142A),
      foregroundColor: Colors.white,
      elevation: 0,

    ),
    iconTheme: const IconThemeData(
      color: Color(0xff1865E8),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xff1865E8),
        foregroundColor: Colors.white,


      ),
    ),
    dividerColor: Color(0xff24334A),

    cardColor: const Color(0xff0D142A),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xff80A9CC),
    ),



  );




}
