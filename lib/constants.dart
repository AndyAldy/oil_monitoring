import 'package:flutter/material.dart';

class AppColors {
  // Warna dominan RoadSync (Hitam, Putih, Merah Honda)
  static const Color background = Color(0xFF121212); // Hitam pekat
  static const Color surface = Color(0xFF1E1E1E);    // Abu gelap untuk kartu
  static const Color primary = Color(0xFFD32F2F);    // Merah
  static const Color accent = Color(0xFF03DAC6);     // Cyan untuk indikator aktif
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
}

final ThemeData roadSyncTheme = ThemeData.dark().copyWith(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    centerTitle: true,
  ),
  cardColor: AppColors.surface,
);