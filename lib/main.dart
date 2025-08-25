import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arr/core/database/hive_database.dart';
import 'package:arr/core/router/app_router.dart';

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
    return MaterialApp.router(
      title: '*arr Stack Manager',
      debugShowCheckedModeBanner: false,
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
      routerConfig: AppRouter.router,
    );
  }
}