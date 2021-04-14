import 'package:flutter/material.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    // fontFamily: 'Poppins-Light',
    scaffoldBackgroundColor: Colors.grey[100],
    fontFamily: "Roboto",
    appBarTheme: AppBarTheme(
      color: Colors.white,
      textTheme: TextTheme(
        caption: TextStyle(
          color: Colors.black,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.blueGrey,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.white,
      onPrimary: Colors.black,
      primaryVariant: Colors.white38,
      secondary: Color(0xFFD4AF37),
      onSecondary: Colors.blueGrey,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.grey[350],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black),
    iconTheme: IconThemeData(
      color: Colors.blueGrey,
    ),
    textTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        // fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.blueGrey,
        // fontSize: 18.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF000a12),
    cardColor: Color(0xFF303030),
    fontFamily: "Roboto",
    appBarTheme: AppBarTheme(
      color: Color(0xFF303030),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      primaryVariant: Color(0xFF141d26),
      secondary: Color(0xFFD4AF37),
      onSecondary: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF303040),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF000a20),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white),
    iconTheme: IconThemeData(
      color: Colors.white54,
    ),
    textTheme: TextTheme(
      caption: TextStyle(color: Colors.white),
      headline6: TextStyle(
        color: Colors.white,
        // fontSize: 20.0,
      ),
      subtitle2: TextStyle(
        color: Colors.white70,
        // fontSize: 18.0,
      ),
    ),
  );

  static Future<bool> get themeValue async {
    try {
      var preferences = await SharedPreferences.getInstance();
      bool value = preferences.getBool(Constants.THEME_PREF_KEY)!;
      print('Theme value:$value');
      return value;
    } catch (e) {
      print('Fetch theme error:${e.toString()}');
      return false;
    }
  }

  static Future<bool> setThemeValue(bool val) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      bool value = await preferences.setBool(Constants.THEME_PREF_KEY, val);
      print("Theme set to:$value");
      return val;
    } catch (e) {
      print('Set theme error:${e.toString()}');
      return false;
    }
  }

  static Future<bool> get isFirstTimeUser async {
    try {
      var preferences = await SharedPreferences.getInstance();
      bool value = preferences.getBool(Constants.FIRST_TIME_USER_PREF_KEY)!;
      return value;
    } catch (e) {
      print('get first time user error:${e.toString()}');
      return false;
    }
  }

  static Future<bool> setFirstTimeUser(bool val) async {
    try {
      var preferences = await SharedPreferences.getInstance();
      bool value =
          await preferences.setBool(Constants.FIRST_TIME_USER_PREF_KEY, val);
      print("First time user set to:$value");
      return val;
    } catch (e) {
      print('Set First time user error:${e.toString()}');
      return false;
    }
  }
}
