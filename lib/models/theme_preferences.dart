// ignore_for_file: constant_identifier_names

import 'package:shared_preferences/shared_preferences.dart';

class ThemePreference {
  static const THEME_MODE = "MODE";
  static const DARK = "DARK";
  static const LIGHT = "LIGHT";

  setModeTeme(String theme) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(THEME_MODE, theme);
  }


  Future<String> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(THEME_MODE) ?? LIGHT;
  }

}