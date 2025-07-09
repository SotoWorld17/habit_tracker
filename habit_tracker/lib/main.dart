import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'habit_tracker_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 60, 91, 183)),
        useMaterial3: true,
      ),
      // Configurar la página inicial como LoginScreen
      home: LoginScreen(),
      routes: {
        '/login-screen': (context) => LoginScreen(),
        '/register-screen': (context) => RegisterScreen(),
        '/habit-tracker': (context) => const HabitTrackerScreen(username: 'Usuario'),
      },
    );
  }
}
