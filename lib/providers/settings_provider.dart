import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/enums/progress_unit.dart';

class SettingsState {
  final ThemeMode themeMode;
  final bool dynamicColor;
  final ProgressUnit defaultProgressUnit;

  const SettingsState({
    required this.themeMode,
    required this.dynamicColor,
    required this.defaultProgressUnit,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    bool? dynamicColor,
    ProgressUnit? defaultProgressUnit,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      dynamicColor: dynamicColor ?? this.dynamicColor,
      defaultProgressUnit: defaultProgressUnit ?? this.defaultProgressUnit,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  SharedPreferences? get _prefs => ref.read(sharedPreferencesProvider);

  @override
  SettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      themeMode: _parseThemeMode(prefs?.getString('theme_mode')),
      dynamicColor: prefs?.getBool('dynamic_color') ?? true,
      defaultProgressUnit:
          ProgressUnit.fromValue(prefs?.getString('default_unit') ?? 'chapter'),
    );
  }

  static ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _prefs?.setString('theme_mode', mode.name);
  }

  Future<void> setDynamicColor(bool enabled) async {
    state = state.copyWith(dynamicColor: enabled);
    await _prefs?.setBool('dynamic_color', enabled);
  }

  Future<void> setDefaultProgressUnit(ProgressUnit unit) async {
    state = state.copyWith(defaultProgressUnit: unit);
    await _prefs?.setString('default_unit', unit.value);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences?>((ref) {
  // Overridden in main.dart
  return null;
});

final settingsProvider =
    NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
