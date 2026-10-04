import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import '../../core/logging/app_logger.dart';

class SecurityService {
  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuth;

  static const String _keyAppLockEnabled = 'app_lock_enabled';
  static const String _keyPinHash = 'pin_hash';
  static const String _keyPinSalt = 'pin_salt';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLockTimeout = 'lock_timeout_seconds';
  static const String _keyFailedAttempts = 'failed_attempts';
  static const String _keyLockoutUntil = 'lockout_until_epoch_ms';

  static const int maxFailedAttempts = 5;
  static const int lockoutDurationSeconds = 30;

  SecurityService({
    FlutterSecureStorage? storage,
    LocalAuthentication? localAuth,
  })  : _storage = storage ?? const FlutterSecureStorage(aOptions: AndroidOptions()),
        _localAuth = localAuth ?? LocalAuthentication();

  Future<bool> isAppLockEnabled() async {
    final val = await _storage.read(key: _keyAppLockEnabled);
    return val == 'true';
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await _storage.write(key: _keyAppLockEnabled, value: enabled.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final val = await _storage.read(key: _keyBiometricEnabled);
    return val == 'true';
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _storage.write(key: _keyBiometricEnabled, value: enabled.toString());
  }

  Future<int> getLockTimeoutSeconds() async {
    final val = await _storage.read(key: _keyLockTimeout);
    return val != null ? int.tryParse(val) ?? 30 : 30;
  }

  Future<void> setLockTimeoutSeconds(int seconds) async {
    await _storage.write(key: _keyLockTimeout, value: seconds.toString());
  }

  Future<bool> hasPin() async {
    final hash = await _storage.read(key: _keyPinHash);
    return hash != null && hash.isNotEmpty;
  }

  /// Hashes the given [pin] with a newly generated cryptographically secure salt
  /// and saves both salt and hash into hardware-backed secure storage.
  Future<void> setPin(String pin) async {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
    final salt = base64Encode(saltBytes);

    final hash = _hashPin(pin, salt);

    await _storage.write(key: _keyPinSalt, value: salt);
    await _storage.write(key: _keyPinHash, value: hash);
    await _storage.write(key: _keyAppLockEnabled, value: 'true');
    await _resetAttempts();
  }

  String _hashPin(String pin, String salt) {
    final bytes = utf8.encode('$salt:$pin');
    return sha256.convert(bytes).toString();
  }

  /// Verifies [pin] against the stored salt & hash.
  /// Handles brute-force tracking and lockouts.
  Future<bool> verifyPin(String pin) async {
    final remaining = await getRemainingLockoutSeconds();
    if (remaining > 0) {
      return false;
    }

    final salt = await _storage.read(key: _keyPinSalt);
    final expectedHash = await _storage.read(key: _keyPinHash);

    if (salt == null || expectedHash == null) {
      return false;
    }

    final computedHash = _hashPin(pin, salt);
    final isMatch = computedHash == expectedHash;

    if (isMatch) {
      await _resetAttempts();
      return true;
    } else {
      await _recordFailedAttempt();
      return false;
    }
  }

  Future<int> getRemainingLockoutSeconds() async {
    final untilStr = await _storage.read(key: _keyLockoutUntil);
    if (untilStr == null) return 0;
    final untilMs = int.tryParse(untilStr) ?? 0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    if (nowMs >= untilMs) {
      return 0;
    }
    return ((untilMs - nowMs) / 1000).ceil();
  }

  Future<int> getFailedAttempts() async {
    final val = await _storage.read(key: _keyFailedAttempts);
    return val != null ? int.tryParse(val) ?? 0 : 0;
  }

  Future<void> _recordFailedAttempt() async {
    final attempts = (await getFailedAttempts()) + 1;
    await _storage.write(key: _keyFailedAttempts, value: attempts.toString());

    if (attempts >= maxFailedAttempts) {
      final lockoutMs = DateTime.now().millisecondsSinceEpoch +
          (lockoutDurationSeconds * 1000);
      await _storage.write(
          key: _keyLockoutUntil, value: lockoutMs.toString());
    }
  }

  Future<void> _resetAttempts() async {
    await _storage.delete(key: _keyFailedAttempts);
    await _storage.delete(key: _keyLockoutUntil);
  }

  /// Disables App Lock and clears PIN credentials.
  Future<void> removePin() async {
    await _storage.delete(key: _keyPinSalt);
    await _storage.delete(key: _keyPinHash);
    await _storage.delete(key: _keyAppLockEnabled);
    await _storage.delete(key: _keyBiometricEnabled);
    await _resetAttempts();
  }

  /// Checks if device hardware supports biometrics (fingerprint/face)
  /// and if at least one biometric is enrolled.
  Future<bool> canAuthenticateWithBiometrics() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isSupported = await _localAuth.isDeviceSupported();
      if (!canCheck && !isSupported) return false;

      final available = await _localAuth.getAvailableBiometrics();
      return canCheck || available.isNotEmpty;
    } on PlatformException catch (e, stack) {
      AppLogger.warn(
          'Biometric capability check failed: ${e.message}', 'SecurityService', e, stack);
      return false;
    } catch (e, stack) {
      AppLogger.error(
          'Unexpected biometric check error', 'SecurityService', e, stack);
      return false;
    }
  }

  /// Authenticates using biometrics.
  /// NOTE: biometricOnly is strictly true so it NEVER falls back to phone screen PIN.
  Future<bool> authenticateBiometrics({
    String reason = 'Scan your fingerprint or face to unlock Suci',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on PlatformException catch (e, stack) {
      AppLogger.warn(
          'Biometric auth platform error: ${e.code} - ${e.message}', 'SecurityService', e, stack);
      return false;
    } catch (e, stack) {
      AppLogger.error(
          'Unexpected biometric auth error', 'SecurityService', e, stack);
      return false;
    }
  }
}
