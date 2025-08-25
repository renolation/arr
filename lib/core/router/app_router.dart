import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:arr/features/sonarr/pages/sonarr_page.dart';
import 'package:arr/features/sonarr/pages/series_detail_page.dart';
import 'package:arr/features/radarr/pages/radarr_page.dart';
import 'package:arr/features/radarr/pages/movie_detail_page.dart';
import 'package:arr/features/settings/pages/settings_page.dart';
import 'package:arr/models/hive/series_hive.dart';
import 'package:arr/models/hive/movie_hive.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/sonarr',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SonarrPage(),
            ),
            routes: [
              GoRoute(
                path: 'series/:id',
                builder: (context, state) {
                  final series = state.extra as SeriesHive;
                  return SeriesDetailPage(series: series);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/radarr',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RadarrPage(),
            ),
            routes: [
              GoRoute(
                path: 'movie/:id',
                builder: (context, state) {
                  final movie = state.extra as MovieHive;
                  return MovieDetailPage(movie: movie);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    
    int selectedIndex = 0;
    if (location.startsWith('/home')) {
      selectedIndex = 0;
    } else if (location.startsWith('/sonarr')) {
      selectedIndex = 1;
    } else if (location.startsWith('/radarr')) {
      selectedIndex = 2;
    } else if (location.startsWith('/settings')) {
      selectedIndex = 3;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/sonarr');
              break;
            case 2:
              context.go('/radarr');
              break;
            case 3:
              context.go('/settings');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.tv),
            label: 'Sonarr',
          ),
          NavigationDestination(
            icon: Icon(Icons.movie),
            label: 'Radarr',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('*arr Stack Manager'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.dashboard,
                  size: 100,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Welcome to *arr Stack Manager',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Manage your Sonarr and Radarr services from one place',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/settings');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Configure Services'),
                ),
                const SizedBox(height: 48),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Quick Tips',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        const ListTile(
                          leading: Icon(Icons.settings),
                          title: Text('Configure your services'),
                          subtitle: Text('Add your Sonarr and Radarr endpoints in Settings'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.tv),
                          title: Text('Browse TV Shows'),
                          subtitle: Text('View and manage your TV show library'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.movie),
                          title: Text('Browse Movies'),
                          subtitle: Text('View and manage your movie collection'),
                        ),
                        const ListTile(
                          leading: Icon(Icons.offline_bolt),
                          title: Text('Offline Support'),
                          subtitle: Text('Your media is cached for offline viewing'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}