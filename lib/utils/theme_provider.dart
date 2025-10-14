import 'package:flutter/material.dart';

enum ThemeMode {
  light,
  dark,
  system,
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
  }

  String getThemeModeLabel() {
    switch (_themeMode) {
      case ThemeMode.light:
        return '亮色模式';
      case ThemeMode.dark:
        return '深色模式';
      case ThemeMode.system:
        return '跟随系统';
    }
  }
}
