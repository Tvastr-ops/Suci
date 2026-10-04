import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_logger.dart';

/// Monitors Riverpod provider lifecycles and unhandled errors.
final class AppProviderObserver extends ProviderObserver {
  const AppProviderObserver();

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    AppLogger.debug(
      'Updated: ${context.provider.name ?? context.provider.runtimeType} -> $newValue',
      'Riverpod',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    AppLogger.error(
      'Provider failed: ${context.provider.name ?? context.provider.runtimeType}',
      'Riverpod',
      error,
      stackTrace,
    );
  }
}
