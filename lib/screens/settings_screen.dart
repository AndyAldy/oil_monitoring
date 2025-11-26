import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart'; //

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedMusicApp = 'spotify'; // Default Musik
  bool _isDarkMode = true; // Default Tema (Gelap)

  @override
  void initState() {
    super.initState();
    _loadPreference();
  }

  // Muat semua settingan yang tersimpan
  void _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMusicApp = prefs.getString('music_app') ?? 'spotify';
      // Muat preferensi tema, default true (Dark Mode)
      _isDarkMode = prefs.getBool('is_dark_mode') ?? true;
    });
  }

  // Simpan settingan musik
  void _saveMusicPreference(String appKey) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('music_app', appKey);
    setState(() {
      _selectedMusicApp = appKey;
    });
  }

  // Simpan settingan tema (Boolean)
  void _saveThemePreference(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark_mode', isDark);
    setState(() {
      _isDarkMode = isDark;
    });
    
    // Catatan: Agar tema seluruh aplikasi berubah secara real-time, 
    // Anda perlu mengupdate main.dart untuk mendengarkan perubahan ini.
    // (Biasanya menggunakan ValueNotifier atau State Management).
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PENGATURAN")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- BAGIAN 1: APLIKASI MUSIK ---
            const Text(
              "Aplikasi Musik Default",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 10),
            
            _buildOptionItem(
              title: "Spotify", 
              isSelected: _selectedMusicApp == 'spotify',
              icon: Icons.music_note,
              onTap: () => _saveMusicPreference('spotify'),
            ),
            const SizedBox(height: 10),
            
            _buildOptionItem(
              title: "YouTube Music", 
              isSelected: _selectedMusicApp == 'ytmusic',
              icon: Icons.play_circle_filled,
              onTap: () => _saveMusicPreference('ytmusic'),
            ),

            const SizedBox(height: 30), // Jarak antar bagian

            // --- BAGIAN 2: TEMA APLIKASI (Update Baru) ---
            const Text(
              "Tampilan Aplikasi",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 10),

            // Widget Switch untuk Tema
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    _isDarkMode ? Icons.dark_mode : Icons.light_mode, 
                    color: Colors.white
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isDarkMode ? "Mode Gelap" : "Mode Terang",
                      style: const TextStyle(
                        color: Colors.white, 
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

  // Widget Helper untuk item pilihan (agar kode lebih rapi)
  Widget _buildOptionItem({
    required String title, 
    required bool isSelected, 
    required IconData icon,
    required VoidCallback onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white, 
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