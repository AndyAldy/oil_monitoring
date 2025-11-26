import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/dashboard_card.dart';
import 'oil_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header Status Motor
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.motorcycle, size: 32, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("ADV 160", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Connected", style: TextStyle(color: Colors.green, fontSize: 12)),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.bluetooth_connected, color: Colors.blue),
                  const SizedBox(width: 10),
                  const Icon(Icons.battery_full, color: Colors.green),
                ],
              ),
            ),

            // Grid Menu Utama
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(16),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  DashboardCard(
                    icon: Icons.navigation,
                    title: "Navigasi",
                    subtitle: "Google Maps",
                    onTap: () {}, // Nanti bisa diisi fungsi navigasi
                  ),
                  DashboardCard(
                    icon: Icons.oil_barrel, // Ikon Oli
                    title: "Monitor Oli",
                    subtitle: "Cek Kondisi",
                    isActive: true, // Highlight menu ini
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OilScreen()),
                      );
                    },
                  ),
                  DashboardCard(
                    icon: Icons.music_note,
                    title: "Musik",
                    subtitle: "Spotify",
                    onTap: () {},
                  ),
                  DashboardCard(
                    icon: Icons.call,
                    title: "Telepon",
                    subtitle: "Riwayat",
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Footer Voice Assistant (Khas RoadSync)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: AppColors.surface,
              child: Column(
                children: const [
                  Icon(Icons.mic, size: 40, color: AppColors.primary),
                  SizedBox(height: 8),
                  Text("Tekan tombol stang untuk bicara", style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}