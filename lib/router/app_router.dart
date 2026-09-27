import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../ui/library/library_screen.dart';
import '../ui/settings/settings_screen.dart';
import '../ui/work_detail/work_detail_screen.dart';
import '../ui/work_form/add_edit_work_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/library',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/library',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: LibraryScreen(),
          ),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SettingsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/work/add',
      builder: (context, state) => const AddEditWorkScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/work/edit/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return AddEditWorkScreen(workId: id);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/work/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return WorkDetailScreen(workId: id);
      },
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  void _onDestinationSelected(BuildContext context, int index) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = location.startsWith('/settings') ? 1 : 0;
    if (currentIndex == index) return;

    // Dismiss any open modal bottom sheets, menus, or dialogs before navigating
    final shellNav = _shellNavigatorKey.currentState;
    while (shellNav != null && shellNav.canPop()) {
      shellNav.pop();
    }
    final rootNav = _rootNavigatorKey.currentState;
    while (rootNav != null && rootNav.canPop()) {
      rootNav.pop();
    }

    if (index == 0) {
      context.go('/library');
    } else {
      context.go('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = location.startsWith('/settings') ? 1 : 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        if (isWide) {
          final theme = Theme.of(context);
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) => _onDestinationSelected(context, index),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: theme.colorScheme.surface,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.auto_stories_outlined),
                      selectedIcon: Icon(Icons.auto_stories_rounded),
                      label: Text('Library'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.settings_outlined),
                      selectedIcon: Icon(Icons.settings_rounded),
                      label: Text('Settings'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: child),
              ],
            ),
          );
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) => _onDestinationSelected(context, index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.auto_stories_outlined),
                selectedIcon: Icon(Icons.auto_stories_rounded),
                label: 'Library',
              ),
              NavigationDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings_rounded),
                label: 'Settings',
              ),
            ],
          ),
        );
      },
    );
  }
}

