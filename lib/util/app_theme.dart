import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ni_trades/util/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  //
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Poppins-Medium",
    cardColor: Color(0xFF393939).withOpacity(0.1),
    appBarTheme: AppBarTheme(
      color: Colors.white,
      brightness: Brightness.light,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
      ),
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
      secondary: Color(0xFFfcfa23c),
      onSecondary: Colors.blueGrey,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF393939).withOpacity(0.1),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
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
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //   SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  //   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF121212),
    cardColor: Color(0xFF393939),
    fontFamily: "Poppins-Medium",
    appBarTheme: AppBarTheme(
      color: Color(0xFF121212),
      brightness: Brightness.dark,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Color(0xFF121212),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.white,
      primaryVariant: Color(0xFF141d26),
      secondary: Color(0xFFfcfa23c),
      onSecondary: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Color(0xFF393939),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF4f4a4c),
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
      var object = preferences.get(Constants.FIRST_TIME_USER_PREF_KEY);
      // if (object == null) {
      //   return false;
      // } else {
      bool value = preferences.getBool(Constants.THEME_PREF_KEY)!;
      print('Theme value:$value');
      return value;
      // }
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
      var object = preferences.get(Constants.FIRST_TIME_USER_PREF_KEY);
      if (object == null) {
        return true;
      } else {
        bool value = preferences.getBool(Constants.FIRST_TIME_USER_PREF_KEY)!;
        return value;
      }
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

  static Color alphaBlend(Color foreground, Color background) {
    final int alpha = foreground.alpha;
    if (alpha == 0x00) {
      // Foreground completely transparent.
      return background;
    }
    final int invAlpha = 0xff - alpha;
    int backAlpha = background.alpha;
    if (backAlpha == 0xff) {
      // Opaque background case
      return Color.fromARGB(
        0xff,
        (alpha * foreground.red + invAlpha * background.red) ~/ 0xff,
        (alpha * foreground.green + invAlpha * background.green) ~/ 0xff,
        (alpha * foreground.blue + invAlpha * background.blue) ~/ 0xff,
      );
    } else {
      // General case
      backAlpha = (backAlpha * invAlpha) ~/ 0xff;
      final int outAlpha = alpha + backAlpha;
      assert(outAlpha != 0x00);
      return Color.fromARGB(
        outAlpha,
        (foreground.red * alpha + background.red * backAlpha) ~/ outAlpha,
        (foreground.green * alpha + background.green * backAlpha) ~/ outAlpha,
        (foreground.blue * alpha + background.blue * backAlpha) ~/ outAlpha,
      );
    }
  }

  static Color getTextColor(Color color) {
    int d = 0;

// Counting the perceptive luminance - human eye favors green color...
    double luminance =
        (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    if (luminance > 0.5)
      d = 0; // bright colors - black font
    else
      d = 255; // dark colors - white font

    return Color.fromARGB(color.alpha, d, d, d);
  }
}
