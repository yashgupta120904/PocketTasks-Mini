import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PocketTasksApp());
}


class PocketTasksApp extends StatelessWidget {
  const PocketTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider()..initialize(),
      child: MaterialApp(
        title: 'PocketTasks',
        debugShowCheckedModeBanner: false,
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }

 
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ).copyWith(
        surface: Colors.grey[50],
        primary: Colors.blue[600],
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Dark theme configuration matching the design
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF2E1065), // Purple background
        surface: Color(0xFF3D1A78), // Slightly lighter purple
        primary: Color(0xFF7C4DFF),
        secondary: Color(0xFF4CAF50),
        onBackground: Colors.white,
        onSurface: Colors.white,
        onPrimary: Colors.white,
      ),
      textTheme: const TextTheme(
        titleMedium: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
