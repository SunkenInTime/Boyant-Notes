import 'package:flutter/material.dart';

const Color purpleBg = Color.fromRGBO(20, 20, 20, 1);
const Color purplePrimary = Color.fromARGB(255, 107, 65, 114);

class MyThemes {
  static final purpleTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: purplePrimary,
      secondary: purplePrimary,
    ),
    primaryColor: purplePrimary,
    scaffoldBackgroundColor: purpleBg,
    primaryTextTheme: Typography().white,
    textTheme: Typography().white,
    iconTheme: const IconThemeData(color: Colors.white),
    unselectedWidgetColor: const Color.fromARGB(255, 102, 102, 102),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white70),
    ),

    //Change
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      unselectedItemColor: Colors.white54,
      showUnselectedLabels: false,
      backgroundColor: purplePrimary,
      selectedIconTheme: IconThemeData(color: Colors.white),
      unselectedIconTheme: IconThemeData(color: Colors.white54),
      showSelectedLabels: true,
      selectedItemColor: Colors.white,
    ),
    // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.)
  );
}
