import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:arr/features/overview/presentation/pages/overview_page.dart';
import 'package:arr/features/library/presentation/pages/library_page.dart';
import 'package:arr/features/requests/presentation/pages/requests_page.dart';
import 'package:arr/features/activity/presentation/pages/activity_page.dart';

/// App router configuration using go_router
class AppRouter {
  static const String overviewPath = '/overview';
  static const String libraryPath = '/library';
  static const String requestsPath = '/requests';
  static const String activityPath = '/activity';
  static const String settingsPath = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: overviewPath,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: overviewPath,
                pageBuilder: (context, state) => const MaterialPage(
                  key: ValueKey('overview'),
                  child: OverviewPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: libraryPath,
                pageBuilder: (context, state) => const MaterialPage(
                  key: ValueKey('library'),
                  child: LibraryPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: requestsPath,
                pageBuilder: (context, state) => const MaterialPage(
                  key: ValueKey('requests'),
                  child: RequestsPage(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: activityPath,
                pageBuilder: (context, state) => const MaterialPage(
                  key: ValueKey('activity'),
                  child: ActivityPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
          ],
        ),
      ),
    ),
  );
}

/// Main scaffold with bottom navigation bar
class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Overview',
          ),
          NavigationDestination(
            icon: Icon(Icons.collections_bookmark_outlined),
            selectedIcon: Icon(Icons.collections_bookmark),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.request_page_outlined),
            selectedIcon: Icon(Icons.request_page),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.download_outlined),
            selectedIcon: Icon(Icons.download),
            label: 'Activity',
          ),
        ],
      ),
    );
  }
}
