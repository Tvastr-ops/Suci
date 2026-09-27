import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'lock_screen.dart';

class AppLockGate extends ConsumerStatefulWidget {
  final Widget child;

  const AppLockGate({super.key, required this.child});

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  bool _isBackgrounded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(authProvider.notifier);

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        setState(() => _isBackgrounded = true);
        notifier.onAppPaused();
        break;
      case AppLifecycleState.inactive:
        setState(() => _isBackgrounded = true);
        break;
      case AppLifecycleState.resumed:
        setState(() => _isBackgrounded = false);
        notifier.onAppResumed();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // If app lock is enabled and state is locked, present LockScreen
    if (authState.isLockEnabled && authState.isLocked) {
      return const LockScreen();
    }

    // When backgrounded or switching apps, show privacy shield if lock is enabled
    if (authState.isLockEnabled && _isBackgrounded) {
      final colorScheme = Theme.of(context).colorScheme;
      return Container(
        color: colorScheme.surface,
        alignment: Alignment.center,
        child: Icon(
          Icons.shield_outlined,
          size: 64,
          color: colorScheme.primary.withValues(alpha: 0.5),
        ),
      );
    }

    return widget.child;
  }
}
