import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visionary_lens/providers/auth_provider.dart';
import 'package:visionary_lens/providers/vision_provider.dart';
import 'package:visionary_lens/views/login_view.dart';
import 'package:visionary_lens/views/home_view.dart';
import 'package:visionary_lens/widgets/accessibility_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => VisionProvider()),
      ],
      child: const VisionaryLensApp(),
    ),
  );
}

class VisionaryLensApp extends StatelessWidget {
  const VisionaryLensApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visionary Lens',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 20, color: Colors.white70),
        ),
      ),
      builder: (context, child) {
        return AccessibilityWrapper(child: child!);
      },
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? const HomeView() : const LoginView();
        },
      ),
    );
  }
}
