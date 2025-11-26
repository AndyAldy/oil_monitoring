import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahkan ini
import 'constants.dart';
import 'screens/dashboard.dart';

// 1. Buat Notifier Global (Bisa diakses dari mana saja)
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

void main() async {
  // 2. Cek settingan tersimpan SEBELUM aplikasi jalan
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  isDarkModeNotifier.value = prefs.getBool('is_dark_mode') ?? true;

  runApp(const OilMonitorApp());
}

class OilMonitorApp extends StatelessWidget {
  const OilMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Bungkus MaterialApp dengan ValueListenableBuilder
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Aplikasi Monitor',
          debugShowCheckedModeBanner: false,
          
          // Definisikan kedua tema
          theme: roadSyncLightTheme, // Tema Terang
          darkTheme: roadSyncTheme,  // Tema Gelap
          
          // Tentukan tema berdasarkan nilai notifier
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          
          home: const HomeScreen(),
        );
      },
    );
  }
}