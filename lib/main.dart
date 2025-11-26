import 'package:flutter/material.dart';
import 'constants.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(const OilMonitorApp());
}

class OilMonitorApp extends StatelessWidget {
  const OilMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oil Monitor Sync',
      debugShowCheckedModeBanner: false,
      theme: roadSyncTheme, // Menggunakan tema gelap custom kita
      home: const HomeScreen(),
    );
  }
}