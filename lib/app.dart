import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart' as mui;
import 'providers/settings_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';
import 'ui/security/app_lock_gate.dart';

class SuciApp extends ConsumerWidget {
  const SuciApp({super.key});

  static ColorScheme? _toFlutterScheme(mui.ColorScheme? scheme) {
    if (scheme == null) return null;
    return ColorScheme(
      brightness: scheme.brightness,
      primary: scheme.primary,
      onPrimary: scheme.onPrimary,
      primaryContainer: scheme.primaryContainer,
      onPrimaryContainer: scheme.onPrimaryContainer,
      secondary: scheme.secondary,
      onSecondary: scheme.onSecondary,
      secondaryContainer: scheme.secondaryContainer,
      onSecondaryContainer: scheme.onSecondaryContainer,
      tertiary: scheme.tertiary,
      onTertiary: scheme.onTertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      onTertiaryContainer: scheme.onTertiaryContainer,
      error: scheme.error,
      onError: scheme.onError,
      errorContainer: scheme.errorContainer,
      onErrorContainer: scheme.onErrorContainer,
      surface: scheme.surface,
      onSurface: scheme.onSurface,
      outline: scheme.outline,
      outlineVariant: scheme.outlineVariant,
      shadow: scheme.shadow,
      scrim: scheme.scrim,
      inverseSurface: scheme.inverseSurface,
      onInverseSurface: scheme.onInverseSurface,
      inversePrimary: scheme.inversePrimary,
      surfaceTint: scheme.surfaceTint,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final useDynamic = settings.dynamicColor;
        final palette = AppPalettes.fromId(settings.customPalette);
        final lightScheme = useDynamic ? _toFlutterScheme(lightDynamic) : null;
        final darkScheme = useDynamic ? _toFlutterScheme(darkDynamic) : null;

        return MaterialApp.router(
          title: 'Suci',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: AppTheme.lightTheme(lightScheme, palette.primary),
          darkTheme: AppTheme.darkTheme(darkScheme, palette.primary),
          routerConfig: appRouter,
          builder: (context, child) =>
              AppLockGate(child: child ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
