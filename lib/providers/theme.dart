import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  Brightness _brightness = Brightness.light;

  Brightness get brightness => _brightness;

  // set initial brightness
  ThemeProvider() {
    _brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  }

  set brightness(Brightness value) {
    _brightness = value;
    notifyListeners();
  }

  ThemeMode get themeMode {
    if (_brightness == Brightness.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark;
    }
  }

  set themeMode(ThemeMode value) {
    if (value == ThemeMode.light) {
      _brightness = Brightness.light;
    } else {
      _brightness = Brightness.dark;
    }
    notifyListeners();
  }

  void changeTheme() {
    if (_brightness == Brightness.light) {
      _brightness = Brightness.dark;
    } else {
      _brightness = Brightness.light;
    }
    notifyListeners();
  }
}
