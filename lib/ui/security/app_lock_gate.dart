import 'package:material_ui/material_ui.dart';
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
    final isShieldVisible =
        authState.isLockEnabled && _isBackgrounded && !authState.isLocked;
    final isLockVisible = authState.isLockEnabled && authState.isLocked;

    return Stack(
      fit: StackFit.expand,
      children: [
        // The main app tree stays alive and never unmounts, preserving all input fields
        FocusScope(
          canRequestFocus: !isLockVisible && !isShieldVisible,
          child: IgnorePointer(
            ignoring: isLockVisible || isShieldVisible,
            child: ExcludeSemantics(
              excluding: isLockVisible || isShieldVisible,
              child: widget.child,
            ),
          ),
        ),

        // Privacy shield when in background (Android Recents / task switcher)
        if (isShieldVisible)
          Container(
            color: Theme.of(context).colorScheme.surface,
            alignment: Alignment.center,
            child: Icon(
              Icons.shield_outlined,
              size: 64,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
          ),

        // Lock screen overlay when app is locked
        if (isLockVisible)
          const Positioned.fill(
            child: LockScreen(),
          ),
      ],
    );
  }
}
