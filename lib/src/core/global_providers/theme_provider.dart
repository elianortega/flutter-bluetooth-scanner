import 'package:hooks_riverpod/hooks_riverpod.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, bool>((ref) => ThemeNotifier());

/// Defines all the ThemeNotifier logic the app will use
class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier() : super(true);
  void toggleTheme() => state = !state;
}
