import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/features/sonarr/pages/sonarr_page.dart';
import 'package:arr/features/radarr/pages/radarr_page.dart';
import 'package:arr/features/settings/pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive database
  await HiveDatabase.init();
  
  runApp(
    const ProviderScope(
      child: ArrApp(),
    ),
  );
}

class ArrApp extends StatelessWidget {
  const ArrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '*arr Stack Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    const HomePage(),
    const SonarrPage(),
    const RadarrPage(),
    const SettingsPage(),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('*arr Stack Manager'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  // Navigate to settings
                  final scaffold = context.findAncestorStateOfType<_MainScreenState>();
                  scaffold?.setState(() {
                    scaffold._selectedIndex = 3;
                  });
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
    );
  }
}