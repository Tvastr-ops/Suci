import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/settings_provider.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class SuciApp extends ConsumerWidget {
  const SuciApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final useDynamic = settings.dynamicColor;

        return MaterialApp.router(
          title: 'Suci',
          debugShowCheckedModeBanner: false,
          themeMode: settings.themeMode,
          theme: AppTheme.lightTheme(useDynamic ? lightDynamic : null),
          darkTheme: AppTheme.darkTheme(useDynamic ? darkDynamic : null),
          routerConfig: appRouter,
        );
      },
    );
  }
}
