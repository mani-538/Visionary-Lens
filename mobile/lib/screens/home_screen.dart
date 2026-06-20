import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/feature_card.dart';
import 'vision_scan_screen.dart';
import 'history_screen.dart';
import 'auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Visionary Lens 2.0',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back, ${auth.userName ?? "User"} 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'What would you like to scan today?',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    const FeatureCard(
                      icon: Icons.document_scanner_rounded,
                      title: "Vision Scan",
                      subtitle: "Analyze objects",
                      color: Color(0xFF3B82F6),
                      nextScreen: VisionScanScreen(),
                    ),
                    const FeatureCard(
                      icon: Icons.history_rounded,
                      title: "History",
                      subtitle: "Past analyses",
                      color: Color(0xFF10B981),
                      nextScreen: HistoryScreen(),
                    ),
                    FeatureCard(
                      icon: Icons.image_search_rounded,
                      title: "Library",
                      subtitle: "Browse photos",
                      color: const Color(0xFFF59E0B),
                    ),
                    FeatureCard(
                      icon: Icons.settings_rounded,
                      title: "Settings",
                      subtitle: "Configurations",
                      color: const Color(0xFF6366F1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
