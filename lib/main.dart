import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/dashboard.dart'; // Pastikan import ini benar

void main() {
  runApp(const OilMonitorApp());
}

class OilMonitorApp extends StatelessWidget {
  const OilMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Monitor',
      debugShowCheckedModeBanner: false,
      theme: roadSyncTheme, // Menggunakan tema dari constants.dart
      home: const HomeScreen(),
    );
  }
}