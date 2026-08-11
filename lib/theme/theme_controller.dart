import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mirrors the JS theme logic: read `pp-theme` from localStorage, fall back to
/// the OS `prefers-color-scheme`, and persist every toggle.
class ThemeController extends ChangeNotifier {
  static const _key = 'pp-theme';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  SharedPreferences? _prefs;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs?.getString(_key);
    if (saved == 'dark') {
      _mode = ThemeMode.dark;
    } else if (saved == 'light') {
      _mode = ThemeMode.light;
    } else {
      _mode = ThemeMode.system; // honours prefers-color-scheme
    }
    notifyListeners();
  }

  bool isDark(BuildContext context) => switch (_mode) {
        ThemeMode.dark => true,
        ThemeMode.light => false,
        ThemeMode.system =>
          MediaQuery.platformBrightnessOf(context) == Brightness.dark,
      };

  void toggle(BuildContext context) {
    final next = isDark(context) ? ThemeMode.light : ThemeMode.dark;
    _mode = next;
    _prefs?.setString(_key, next == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }
}

/// Exposes the controller to the widget tree without pulling in a state
/// management package.
class ThemeScope extends InheritedNotifier<ThemeController> {
  const ThemeScope({super.key, required ThemeController controller, required super.child})
      : super(notifier: controller);

  static ThemeController of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeScope>()!.notifier!;
}
