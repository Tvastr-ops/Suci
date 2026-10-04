import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/core/logging/app_logger.dart';
import 'package:suci/core/logging/provider_observer.dart';

class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

void main() {
  group('AppLogger', () {
    test('logs without throwing in enabled and disabled modes', () {
      AppLogger.isEnabled = true;
      expect(() => AppLogger.debug('Debug test', 'TestContext'), returnsNormally);
      expect(() => AppLogger.info('Info test'), returnsNormally);
      expect(() => AppLogger.warning('Warn test', 'Test', Exception('warn')), returnsNormally);
      expect(
        () => AppLogger.error('Error test', 'Test', Exception('err'), StackTrace.current),
        returnsNormally,
      );

      AppLogger.isEnabled = false;
      expect(() => AppLogger.debug('Should be suppressed'), returnsNormally);
      expect(() => AppLogger.error('Critical error still handled'), returnsNormally);

      // Reset
      AppLogger.isEnabled = true;
    });
  });

  group('AppProviderObserver', () {
    test('observes provider updates and failures without errors', () {
      final counterProvider = NotifierProvider<CounterNotifier, int>(CounterNotifier.new);
      final errorProvider = Provider<int>((ref) => throw Exception('Intentional test error'));

      final container = ProviderContainer(
        observers: const [AppProviderObserver()],
      );
      addTearDown(container.dispose);

      // Test update
      container.read(counterProvider.notifier).increment();
      expect(container.read(counterProvider), 1);

      // Test failure
      expect(() => container.read(errorProvider), throwsException);
    });
  });
}
