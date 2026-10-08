import 'dart:async';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

class LockScreen extends ConsumerStatefulWidget {
  const LockScreen({super.key});

  @override
  ConsumerState<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends ConsumerState<LockScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _enteredDigits = [];
  bool _isVerifying = false;
  bool _hasError = false;
  Timer? _countdownTimer;
  int _countdown = 0;

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLockoutAndPromptBiometrics();
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _checkLockoutAndPromptBiometrics() {
    final authState = ref.read(authProvider);
    if (authState.remainingLockoutSeconds > 0) {
      _startCountdown(authState.remainingLockoutSeconds);
    } else if (authState.isBiometricEnabled && authState.isBiometricAvailable) {
      ref.read(authProvider.notifier).unlockWithBiometrics();
    }
  }

  void _startCountdown(int seconds) {
    _countdownTimer?.cancel();
    setState(() {
      _countdown = seconds;
      _enteredDigits.clear();
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown <= 1) {
        timer.cancel();
        setState(() => _countdown = 0);
        ref.read(authProvider.notifier).refreshLockout();
      } else {
        setState(() => _countdown--);
      }
    });
  }

  void _onDigitPressed(String digit) {
    if (_isVerifying || _countdown > 0) return;
    if (_enteredDigits.length >= 4) return;

    HapticFeedback.lightImpact();
    setState(() {
      _hasError = false;
      _enteredDigits.add(digit);
    });

    if (_enteredDigits.length == 4) {
      _verifyPin();
    }
  }

  void _onDeletePressed() {
    if (_isVerifying || _countdown > 0 || _enteredDigits.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _hasError = false;
      _enteredDigits.removeLast();
    });
  }

  Future<void> _verifyPin() async {
    setState(() => _isVerifying = true);
    final pin = _enteredDigits.join();

    final success = await ref.read(authProvider.notifier).unlockWithPin(pin);

    if (!mounted) return;

    if (success) {
      HapticFeedback.mediumImpact();
      setState(() {
        _isVerifying = false;
        _enteredDigits.clear();
      });
    } else {
      HapticFeedback.heavyImpact();
      final authState = ref.read(authProvider);
      setState(() {
        _isVerifying = false;
        _hasError = true;
      });

      _shakeController.forward(from: 0.0);

      if (authState.remainingLockoutSeconds > 0) {
        _startCountdown(authState.remainingLockoutSeconds);
      } else {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            setState(() {
              _enteredDigits.clear();
              _hasError = false;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Column(
          children: [
            const Spacer(flex: 2),

            // App Icon & Lock Header
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_rounded,
                size: 34,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Suci',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            if (_countdown > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Too many incorrect attempts.\nTry again in $_countdown seconds',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Text(
                _hasError ? 'Incorrect PIN' : 'Enter PIN to unlock',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: _hasError ? colorScheme.error : colorScheme.onSurfaceVariant,
                  fontWeight: _hasError ? FontWeight.w600 : FontWeight.normal,
                ),
              ),

            const SizedBox(height: 32),

            // PIN Indicator Dots with shake animation
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: child,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredDigits.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _hasError
                          ? colorScheme.error
                          : isFilled
                              ? colorScheme.primary
                              : Colors.transparent,
                      border: Border.all(
                        color: _hasError
                            ? colorScheme.error
                            : isFilled
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const Spacer(flex: 3),

            // Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('1'),
                      _buildKeypadButton('2'),
                      _buildKeypadButton('3'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('4'),
                      _buildKeypadButton('5'),
                      _buildKeypadButton('6'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildKeypadButton('7'),
                      _buildKeypadButton('8'),
                      _buildKeypadButton('9'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Biometric button (if available & enabled)
                      if (authState.isBiometricEnabled &&
                          authState.isBiometricAvailable &&
                          _countdown == 0)
                        _buildIconButton(
                          icon: Icons.fingerprint_rounded,
                          onPressed: () => ref
                              .read(authProvider.notifier)
                              .unlockWithBiometrics(),
                          color: colorScheme.primary,
                        )
                      else
                        const SizedBox(width: 72, height: 72),

                      _buildKeypadButton('0'),

                      // Backspace button
                      _buildIconButton(
                        icon: Icons.backspace_outlined,
                        onPressed: _onDeletePressed,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    ),
  ),
);
  }

  Widget _buildKeypadButton(String digit) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDisabled = _countdown > 0;

    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: isDisabled
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDisabled ? null : () => _onDigitPressed(digit),
          child: Center(
            child: Text(
              digit,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? colorScheme.onSurface.withValues(alpha: 0.3)
                    : colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: Icon(icon, size: 28, color: color),
          ),
        ),
      ),
    );
  }
}
