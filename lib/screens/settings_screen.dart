import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../main.dart'; // PENTING: Import main.dart untuk akses isDarkModeNotifier

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedMusicApp = 'spotify';
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  void _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMusicApp = prefs.getString('music_app') ?? 'spotify';
      _isDarkMode = prefs.getBool('is_dark_mode') ?? true;
    });
  }

  void _saveMusicPreference(String appKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('music_app', appKey);
    setState(() {
      _selectedMusicApp = appKey;
    });
  }

  // UPDATE BAGIAN INI
  void _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
    
    // Update Global Notifier agar main.dart merespon
    isDarkModeNotifier.value = isDark; 

    setState(() {
      _isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sedikit penyesuaian warna teks agar terlihat di mode terang
    final textColor = _isDarkMode ? AppColors.textSecondary : Colors.black54;
    final cardColor = _isDarkMode ? AppColors.surface : Colors.white;
    final iconColor = _isDarkMode ? Colors.white : Colors.black87;
    final borderColor = _isDarkMode ? Colors.transparent : Colors.grey.shade300;

    return Scaffold(
      appBar: AppBar(title: const Text("PENGATURAN")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aplikasi Musik Default",
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            const SizedBox(height: 10),
            
            _buildOptionItem(
              title: "Spotify", 
              isSelected: _selectedMusicApp == 'spotify',
              icon: Icons.music_note,
              onTap: () => _saveMusicPreference('spotify'),
              // Kirim warna dinamis ke helper
              cardColor: cardColor,
              iconColor: iconColor,
              borderColor: borderColor,
            ),
            const SizedBox(height: 10),
            
            _buildOptionItem(
              title: "YouTube Music", 
              isSelected: _selectedMusicApp == 'ytmusic',
              icon: Icons.play_circle_filled,
              onTap: () => _saveMusicPreference('ytmusic'),
              cardColor: cardColor,
              iconColor: iconColor,
              borderColor: borderColor,
            ),

            const SizedBox(height: 30),

            Text(
              "Tampilan Aplikasi",
              style: TextStyle(color: textColor, fontSize: 14),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  Icon(
                    _isDarkMode ? Icons.dark_mode : Icons.light_mode, 
                    color: iconColor
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isDarkMode ? "Mode Gelap" : "Mode Terang",
                      style: TextStyle(
                        color: _isDarkMode ? Colors.white : Colors.black, 
                        fontSize: 16, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Switch(
                    value: _isDarkMode,
                    activeColor: AppColors.primary,
                    onChanged: (value) => _saveThemePreference(value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Update Helper Widget untuk support warna dinamis
  Widget _buildOptionItem({
    required String title, 
    required bool isSelected, 
    required IconData icon,
    required VoidCallback onTap,
    required Color cardColor,
    required Color iconColor,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: iconColor, 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}