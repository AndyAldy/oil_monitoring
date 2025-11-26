import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Wajib untuk Firebase
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'screens/dashboard.dart';

// Notifier Global untuk Tema
final ValueNotifier<bool> isDarkModeNotifier = ValueNotifier(true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Wajib ada sebelum akses native
  
  try {
    await Firebase.initializeApp(); // Inisialisasi koneksi ke Firebase
  } catch (e) {
    debugPrint("Gagal inisialisasi Firebase: $e");
  }

  final prefs = await SharedPreferences.getInstance();
  isDarkModeNotifier.value = prefs.getBool('is_dark_mode') ?? true;

  runApp(const OilMonitorApp());
}

class OilMonitorApp extends StatelessWidget {
  const OilMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'Monitoring Oli',
          debugShowCheckedModeBanner: false,
          theme: roadSyncLightTheme, 
          darkTheme: roadSyncTheme,  
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}