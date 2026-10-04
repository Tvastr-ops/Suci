import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// Lightweight, performance-first logger for Sūcī.
///
/// In release mode, debug-level logs are completely inert to guarantee zero overhead.
class AppLogger {
  AppLogger._();

  static bool isEnabled = kDebugMode;

  static void debug(
    String message, [
    String? context,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log(LogLevel.debug, message, context, error, stackTrace);
  }

  static void info(
    String message, [
    String? context,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log(LogLevel.info, message, context, error, stackTrace);
  }

  static void warning(
    String message, [
    String? context,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log(LogLevel.warning, message, context, error, stackTrace);
  }

  static void warn(
    String message, [
    String? context,
    Object? error,
    StackTrace? stackTrace,
  ]) =>
      warning(message, context, error, stackTrace);

  static void error(
    String message, [
    String? context,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    _log(LogLevel.error, message, context, error, stackTrace);
  }

  static void _log(
    LogLevel level,
    String message, [
    String? context,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    // Only log in debug mode unless it's a critical error
    if (!isEnabled && level != LogLevel.error) return;

    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}.${now.millisecond.toString().padLeft(3, '0')}';
    final tag = level.name.toUpperCase().padRight(5);
    final ctx = context != null ? '[$context] ' : '';

    debugPrint('[$timeStr] $tag $ctx$message');

    if (error != null) {
      debugPrint('   Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('   StackTrace:\n$stackTrace');
    }
  }
}
