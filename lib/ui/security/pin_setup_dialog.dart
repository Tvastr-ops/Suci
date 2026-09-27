import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';

/// Dialog to set up a new 4-digit PIN (Enter PIN -> Confirm PIN).
class PinSetupDialog extends ConsumerStatefulWidget {
  const PinSetupDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PinSetupDialog(),
    );
  }

  @override
  ConsumerState<PinSetupDialog> createState() => _PinSetupDialogState();
}

class _PinSetupDialogState extends ConsumerState<PinSetupDialog> {
  final TextEditingController _firstPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  bool _isConfirming = false;
  String? _errorMessage;

  @override
  void dispose() {
    _firstPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _onNext() {
    final pin = _firstPinController.text.trim();
    if (pin.length != 4) {
      setState(() => _errorMessage = 'PIN must be exactly 4 digits');
      return;
    }
    setState(() {
      _isConfirming = true;
      _errorMessage = null;
    });
  }

  Future<void> _onSave() async {
    final firstPin = _firstPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    if (confirmPin != firstPin) {
      setState(() {
        _errorMessage = 'PINs do not match. Try again.';
        _confirmPinController.clear();
      });
      return;
    }

    await ref.read(authProvider.notifier).setupPin(firstPin);

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.lock_outline_rounded, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(_isConfirming ? 'Confirm PIN' : 'Set App PIN'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isConfirming
                ? 'Re-enter your 4-digit PIN to confirm.'
                : 'Create a private 4-digit PIN to protect your library.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _isConfirming ? _confirmPinController : _firstPinController,
            autofocus: true,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              letterSpacing: 16,
              fontWeight: FontWeight.bold,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••',
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) {
              if (_isConfirming) {
                _onSave();
              } else {
                _onNext();
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_isConfirming) {
              setState(() {
                _isConfirming = false;
                _confirmPinController.clear();
                _errorMessage = null;
              });
            } else {
              Navigator.of(context).pop(false);
            }
          },
          child: Text(_isConfirming ? 'Back' : 'Cancel'),
        ),
        FilledButton(
          onPressed: _isConfirming ? _onSave : _onNext,
          child: Text(_isConfirming ? 'Confirm & Enable' : 'Next'),
        ),
      ],
    );
  }
}

/// Dialog to change existing PIN (Current PIN -> New PIN -> Confirm PIN).
class PinChangeDialog extends ConsumerStatefulWidget {
  const PinChangeDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const PinChangeDialog(),
    );
  }

  @override
  ConsumerState<PinChangeDialog> createState() => _PinChangeDialogState();
}

class _PinChangeDialogState extends ConsumerState<PinChangeDialog> {
  final TextEditingController _currentPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  int _step = 0; // 0: current, 1: new, 2: confirm
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (_step == 0) {
      final currentPin = _currentPinController.text.trim();
      if (currentPin.length != 4) {
        setState(() => _errorMessage = 'Enter your 4-digit PIN');
        return;
      }
      setState(() => _isLoading = true);
      final valid = await ref.read(securityServiceProvider).verifyPin(currentPin);
      if (!mounted) return;
      setState(() => _isLoading = false);

      if (!valid) {
        setState(() {
          _errorMessage = 'Incorrect current PIN';
          _currentPinController.clear();
        });
        return;
      }

      setState(() {
        _step = 1;
        _errorMessage = null;
      });
    } else if (_step == 1) {
      final newPin = _newPinController.text.trim();
      if (newPin.length != 4) {
        setState(() => _errorMessage = 'PIN must be 4 digits');
        return;
      }
      setState(() {
        _step = 2;
        _errorMessage = null;
      });
    } else if (_step == 2) {
      final newPin = _newPinController.text.trim();
      final confirmPin = _confirmPinController.text.trim();
      if (confirmPin != newPin) {
        setState(() {
          _errorMessage = 'PINs do not match';
          _confirmPinController.clear();
        });
        return;
      }

      final success = await ref
          .read(authProvider.notifier)
          .changePin(_currentPinController.text.trim(), newPin);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
      } else {
        setState(() => _errorMessage = 'Failed to update PIN');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String title;
    String subtitle;
    TextEditingController controller;

    if (_step == 0) {
      title = 'Verify Current PIN';
      subtitle = 'Enter your current PIN to continue.';
      controller = _currentPinController;
    } else if (_step == 1) {
      title = 'Enter New PIN';
      subtitle = 'Choose a new 4-digit PIN.';
      controller = _newPinController;
    } else {
      title = 'Confirm New PIN';
      subtitle = 'Re-enter your new 4-digit PIN.';
      controller = _confirmPinController;
    }

    return AlertDialog(
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              )),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              letterSpacing: 16,
              fontWeight: FontWeight.bold,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••',
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) => _onSubmit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _onSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_step == 2 ? 'Save PIN' : 'Next'),
        ),
      ],
    );
  }
}

/// Dialog to verify PIN when disabling App Lock.
class PinConfirmDisableDialog extends ConsumerStatefulWidget {
  const PinConfirmDisableDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => const PinConfirmDisableDialog(),
    );
  }

  @override
  ConsumerState<PinConfirmDisableDialog> createState() =>
      _PinConfirmDisableDialogState();
}

class _PinConfirmDisableDialogState
    extends ConsumerState<PinConfirmDisableDialog> {
  final TextEditingController _pinController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _onDisable() async {
    final pin = _pinController.text.trim();
    if (pin.length != 4) {
      setState(() => _errorMessage = 'Enter your 4-digit PIN');
      return;
    }

    setState(() => _isLoading = true);
    final success =
        await ref.read(authProvider.notifier).disableAppLock(pin);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _errorMessage = 'Incorrect PIN';
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: const Text('Turn Off App Lock?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enter your current PIN to disable app protection.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _pinController,
            autofocus: true,
            keyboardType: TextInputType.number,
            obscureText: true,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium?.copyWith(
              letterSpacing: 16,
              fontWeight: FontWeight.bold,
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              hintText: '••••',
              errorText: _errorMessage,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (_) => _onDisable(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
          ),
          onPressed: _isLoading ? null : _onDisable,
          child: _isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Turn Off'),
        ),
      ],
    );
  }
}
