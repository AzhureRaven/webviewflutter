import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

class SharedPreference extends ChangeNotifier {
  // Static instance
  static final SharedPreference _instance = SharedPreference._internal();
  factory SharedPreference() => _instance;
  SharedPreference._internal();

  late SharedPreferences _prefs;
  static const String _LANG_KEY = 'language_code';
  static const String _THEME_KEY = 'theme';
  String _lang = 'en';
  String _theme = 'auto';

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _lang = _prefs.getString(_LANG_KEY) ?? checkSystemLanguage();
    _theme = _prefs.getString(_THEME_KEY) ?? "auto";
  }

  String checkSystemLanguage(){
    if(window.locale.languageCode == "en" || window.locale.languageCode == "id") {
      return window.locale.languageCode;
    } else {
      return "id";
    }
  }

  Locale getLocale(){
    return Locale(_lang);
  }
  String getLang(){
    return _lang;
  }
  ThemeMode getThemeMode(){
    if(_theme == "auto"){
      return ThemeMode.system;
    }
    else{
      return _theme == "dark" ? ThemeMode.dark:ThemeMode.light;
    }
  }
  String getTheme(){
    return _theme;
  }
  bool isDark(){
    if(_theme == "auto"){
      return window.platformBrightness == Brightness.dark;
    }
    else{
      return _theme == "dark";
    }
  }

  void changeLanguage(String newLocale) async {
    await _prefs.setString(_LANG_KEY, newLocale);
    _lang = newLocale;
    notifyListeners();
  }
  void changeTheme(String newTheme) async {
    await _prefs.setString(_THEME_KEY, newTheme);
    _theme = newTheme;
    notifyListeners();
  }
}