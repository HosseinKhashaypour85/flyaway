import 'package:flutter/material.dart';
import 'package:flyaway/config/app_config/app_colors/app_colors.dart';

class AppThemes {
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: backGroundColor2,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 4),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black87, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
      bodySmall: TextStyle(color: Colors.black54, fontSize: 12),
      titleLarge: TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(color: Colors.black87, fontSize: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backGroundColor2,
      selectedItemColor: Colors.black,
      unselectedItemColor: darkColor,
    ),
    cardColor: primary2Color,
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: darkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF00008B),
      foregroundColor: Colors.white,
      elevation: 1,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 4),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white, fontSize: 12),
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: TextStyle(color: Colors.white, fontSize: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkColor,
      selectedItemColor: Colors.white,
    ),
    cardColor: Colors.grey[800],
  );
}
