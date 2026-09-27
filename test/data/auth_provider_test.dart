import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/services/security_service.dart';
import 'package:suci/providers/auth_provider.dart';
import 'security_service_test.dart';

void main() {
  late FakeSecureStorage fakeStorage;
  late SecurityService securityService;
  late ProviderContainer container;

  setUp(() {
    fakeStorage = FakeSecureStorage();
    securityService = SecurityService(storage: fakeStorage);

    container = ProviderContainer(
      overrides: [
        securityServiceProvider.overrideWithValue(securityService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthProvider Tests', () {
    test('initial state has lock disabled and is not locked', () async {
      container.read(authProvider.notifier);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      final state = container.read(authProvider);
      expect(state.isLockEnabled, isFalse);
      expect(state.isLocked, isFalse);
    });

    test('setupPin enables lock and sets initial unlocked session', () async {
      final notifier = container.read(authProvider.notifier);

      await notifier.setupPin('1234');

      final state = container.read(authProvider);
      expect(state.isLockEnabled, isTrue);
      expect(state.isLocked, isFalse);
    });

    test('unlockWithPin unlocks when locked', () async {
      final notifier = container.read(authProvider.notifier);
      await notifier.setupPin('1234');

      notifier.lockNow();
      expect(container.read(authProvider).isLocked, isTrue);

      final failed = await notifier.unlockWithPin('0000');
      expect(failed, isFalse);
      expect(container.read(authProvider).isLocked, isTrue);

      final success = await notifier.unlockWithPin('1234');
      expect(success, isTrue);
      expect(container.read(authProvider).isLocked, isFalse);
    });

    test('disableAppLock clears lock state when correct pin provided', () async {
      final notifier = container.read(authProvider.notifier);
      await notifier.setupPin('9876');

      final wrongAttempt = await notifier.disableAppLock('0000');
      expect(wrongAttempt, isFalse);
      expect(container.read(authProvider).isLockEnabled, isTrue);

      final rightAttempt = await notifier.disableAppLock('9876');
      expect(rightAttempt, isTrue);
      expect(container.read(authProvider).isLockEnabled, isFalse);
    });
  });
}
