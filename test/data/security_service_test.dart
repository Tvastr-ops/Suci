import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suci/data/services/security_service.dart';

class FakeSecureStorage implements FlutterSecureStorage {
  final Map<String, String> _storage = {};

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    } else {
      _storage.remove(key);
    }
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.remove(key);
  }

  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    _storage.clear();
  }

  @override
  Future<Map<String, String>> readAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return Map.from(_storage);
  }

  @override
  Future<bool> containsKey({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    return _storage.containsKey(key);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late FakeSecureStorage fakeStorage;
  late SecurityService securityService;

  setUp(() {
    fakeStorage = FakeSecureStorage();
    securityService = SecurityService(storage: fakeStorage);
  });

  group('SecurityService PIN & Hashing Tests', () {
    test('initially has no pin and app lock is disabled', () async {
      expect(await securityService.hasPin(), isFalse);
      expect(await securityService.isAppLockEnabled(), isFalse);
    });

    test('setPin saves salted hash and enables lock without plaintext pin',
        () async {
      const pin = '1234';
      await securityService.setPin(pin);

      expect(await securityService.hasPin(), isTrue);
      expect(await securityService.isAppLockEnabled(), isTrue);

      final salt = await fakeStorage.read(key: 'pin_salt');
      final hash = await fakeStorage.read(key: 'pin_hash');

      expect(salt, isNotNull);
      expect(hash, isNotNull);
      // Ensure plaintext PIN is never stored anywhere
      expect(salt, isNot(contains(pin)));
      expect(hash, isNot(contains(pin)));
    });

    test('verifyPin succeeds on correct pin and fails on wrong pin', () async {
      await securityService.setPin('4321');

      final correct = await securityService.verifyPin('4321');
      expect(correct, isTrue);

      final wrong = await securityService.verifyPin('9999');
      expect(wrong, isFalse);
    });

    test('failed attempts trigger lockout after 5 incorrect tries', () async {
      await securityService.setPin('5555');

      expect(await securityService.getRemainingLockoutSeconds(), equals(0));

      for (int i = 0; i < 4; i++) {
        final res = await securityService.verifyPin('0000');
        expect(res, isFalse);
        expect(await securityService.getRemainingLockoutSeconds(), equals(0));
      }

      // 5th attempt triggers lockout
      final fifth = await securityService.verifyPin('0000');
      expect(fifth, isFalse);

      final remaining = await securityService.getRemainingLockoutSeconds();
      expect(remaining, greaterThan(0));

      // During lockout, even the correct PIN returns false
      final duringLockout = await securityService.verifyPin('5555');
      expect(duringLockout, isFalse);
    });

    test('removePin clears all credentials and disables lock', () async {
      await securityService.setPin('1111');
      await securityService.setBiometricEnabled(true);

      await securityService.removePin();

      expect(await securityService.hasPin(), isFalse);
      expect(await securityService.isAppLockEnabled(), isFalse);
      expect(await securityService.isBiometricEnabled(), isFalse);
    });
  });
}
