import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/security_service.dart';

class AuthState {
  final bool isLockEnabled;
  final bool isBiometricEnabled;
  final bool isBiometricAvailable;
  final int timeoutSeconds;
  final bool isLocked;
  final int remainingLockoutSeconds;
  final bool isInitialized;

  const AuthState({
    required this.isLockEnabled,
    required this.isBiometricEnabled,
    required this.isBiometricAvailable,
    required this.timeoutSeconds,
    required this.isLocked,
    required this.remainingLockoutSeconds,
    required this.isInitialized,
  });

  const AuthState.initial()
      : isLockEnabled = false,
        isBiometricEnabled = false,
        isBiometricAvailable = false,
        timeoutSeconds = 0,
        isLocked = false,
        remainingLockoutSeconds = 0,
        isInitialized = false;

  AuthState copyWith({
    bool? isLockEnabled,
    bool? isBiometricEnabled,
    bool? isBiometricAvailable,
    int? timeoutSeconds,
    bool? isLocked,
    int? remainingLockoutSeconds,
    bool? isInitialized,
  }) {
    return AuthState(
      isLockEnabled: isLockEnabled ?? this.isLockEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isBiometricAvailable:
          isBiometricAvailable ?? this.isBiometricAvailable,
      timeoutSeconds: timeoutSeconds ?? this.timeoutSeconds,
      isLocked: isLocked ?? this.isLocked,
      remainingLockoutSeconds:
          remainingLockoutSeconds ?? this.remainingLockoutSeconds,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  DateTime? _pausedAt;
  late SecurityService _security;

  @override
  AuthState build() {
    _security = ref.read(securityServiceProvider);
    state = const AuthState.initial();
    _loadState();
    return state;
  }

  Future<void> _loadState() async {
    final lockEnabled = await _security.isAppLockEnabled();
    final bioEnabled = await _security.isBiometricEnabled();
    final bioAvailable = await _security.canAuthenticateWithBiometrics();
    final timeout = await _security.getLockTimeoutSeconds();
    final remainingLockout = await _security.getRemainingLockoutSeconds();

    if (!ref.mounted) return;

    state = AuthState(
      isLockEnabled: lockEnabled,
      isBiometricEnabled: bioEnabled,
      isBiometricAvailable: bioAvailable,
      timeoutSeconds: timeout,
      isLocked: lockEnabled, // Start locked if enabled
      remainingLockoutSeconds: remainingLockout,
      isInitialized: true,
    );
  }

  void onAppPaused() {
    _pausedAt = DateTime.now();
  }

  Future<void> onAppResumed() async {
    if (!state.isLockEnabled || state.isLocked) return;

    final pausedAt = _pausedAt;
    if (pausedAt == null) return;

    final elapsed = DateTime.now().difference(pausedAt).inSeconds;
    if (elapsed >= state.timeoutSeconds) {
      final remaining = await _security.getRemainingLockoutSeconds();
      state = state.copyWith(
        isLocked: true,
        remainingLockoutSeconds: remaining,
      );
    }
  }

  Future<bool> unlockWithPin(String pin) async {
    final success = await _security.verifyPin(pin);
    final remaining = await _security.getRemainingLockoutSeconds();
    if (success) {
      state = state.copyWith(
        isLocked: false,
        remainingLockoutSeconds: 0,
      );
      return true;
    } else {
      state = state.copyWith(
        remainingLockoutSeconds: remaining,
      );
      return false;
    }
  }

  Future<bool> unlockWithBiometrics() async {
    if (!state.isBiometricEnabled || !state.isBiometricAvailable) return false;
    final remaining = await _security.getRemainingLockoutSeconds();
    if (remaining > 0) return false;

    final authenticated = await _security.authenticateBiometrics();
    if (authenticated) {
      state = state.copyWith(
        isLocked: false,
        remainingLockoutSeconds: 0,
      );
      return true;
    }
    return false;
  }

  Future<void> setupPin(String pin) async {
    await _security.setPin(pin);
    final bioAvailable = await _security.canAuthenticateWithBiometrics();
    state = state.copyWith(
      isLockEnabled: true,
      isBiometricAvailable: bioAvailable,
      isLocked: false,
      remainingLockoutSeconds: 0,
    );
  }

  Future<bool> changePin(String currentPin, String newPin) async {
    final verified = await _security.verifyPin(currentPin);
    if (!verified) {
      final remaining = await _security.getRemainingLockoutSeconds();
      state = state.copyWith(remainingLockoutSeconds: remaining);
      return false;
    }
    await _security.setPin(newPin);
    state = state.copyWith(remainingLockoutSeconds: 0);
    return true;
  }

  Future<bool> disableAppLock(String currentPin) async {
    final verified = await _security.verifyPin(currentPin);
    if (!verified) {
      final remaining = await _security.getRemainingLockoutSeconds();
      state = state.copyWith(remainingLockoutSeconds: remaining);
      return false;
    }
    await _security.removePin();
    state = state.copyWith(
      isLockEnabled: false,
      isBiometricEnabled: false,
      isLocked: false,
      remainingLockoutSeconds: 0,
    );
    return true;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _security.setBiometricEnabled(enabled);
    state = state.copyWith(isBiometricEnabled: enabled);
  }

  Future<void> setTimeoutSeconds(int seconds) async {
    await _security.setLockTimeoutSeconds(seconds);
    state = state.copyWith(timeoutSeconds: seconds);
  }

  void lockNow() {
    if (state.isLockEnabled) {
      state = state.copyWith(isLocked: true);
    }
  }

  Future<void> refreshLockout() async {
    final remaining = await _security.getRemainingLockoutSeconds();
    state = state.copyWith(remainingLockoutSeconds: remaining);
  }
}

final securityServiceProvider = Provider<SecurityService>((ref) {
  return SecurityService();
});

final authProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
