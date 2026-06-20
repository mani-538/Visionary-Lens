import 'package:flutter/material.dart';
import '../core/tts_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isTtsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader("Accessibility"),
          _buildToggleTile(
            icon: Icons.volume_up_rounded,
            title: "Voice Feedback (TTS)",
            subtitle: "Read analysis results automatically",
            value: _isTtsEnabled,
            onChanged: (val) {
              setState(() => _isTtsEnabled = val);
              if (val) TtsHelper.speak("Voice feedback enabled");
            },
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Account"),
          _buildActionTile(
            icon: Icons.person_outline,
            title: "Profile Details",
            onTap: () {},
          ),
          _buildActionTile(
            icon: Icons.security_outlined,
            title: "Privacy & Security",
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("About"),
          _buildActionTile(
            icon: Icons.info_outline,
            title: "Version",
            subtitle: "2.0.0 (Production)",
            onTap: () {},
          ),
          _buildActionTile(
            icon: Icons.description_outlined,
            title: "Terms of Service",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        secondary: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        value: value,
        onChanged: onChanged,
        activeColor: Colors.indigo,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.indigo),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
