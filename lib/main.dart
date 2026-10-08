import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'core/logging/app_logger.dart';
import 'core/logging/provider_observer.dart';
import 'providers/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Global uncaught Flutter error handler
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    AppLogger.error(
      details.exceptionAsString(),
      'FlutterError',
      details.exception,
      details.stack,
    );
  };

  // Global uncaught asynchronous / platform error handler
  PlatformDispatcher.instance.onError = (error, stack) {
    AppLogger.error(
      error.toString(),
      'AsyncPlatform',
      error,
      stack,
    );
    return true;
  };

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SuciApp(),
    ),
  );
}
