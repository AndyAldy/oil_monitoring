import 'package:flutter/material.dart';
import '../constants.dart';

class OilScreen extends StatefulWidget {
  const OilScreen({super.key});

  @override
  State<OilScreen> createState() => _OilScreenState();
}

class _OilScreenState extends State<OilScreen> {
  final TextEditingController _kmController = TextEditingController();
  
  // Contoh data tersimpan (bisa diganti database nanti)
  int _lastOilChangeKm = 10000; 
  int _interval = 2000;
  int _currentKm = 11500;

  int get _remainingKm => (_lastOilChangeKm + _interval) - _currentKm;

  void _updateKm() {
    if (_kmController.text.isNotEmpty) {
      setState(() {
        _currentKm = int.parse(_kmController.text);
      });
      _kmController.clear();
      Navigator.pop(context); // Tutup dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    // Logika warna indikator (Merah jika sudah lewat/dekat, Hijau jika aman)
    Color statusColor = _remainingKm < 500 ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(title: const Text("OIL MONITOR")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Indikator Sisa Jarak (Seperti Fuel Gauge)
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 2),
              ),
              child: Column(
                children: [
                  const Icon(Icons.oil_barrel, size: 60, color: AppColors.textPrimary),
                  const SizedBox(height: 10),
                  Text(
                    "$_remainingKm KM",
                    style: TextStyle(
                      fontSize: 48, 
                      fontWeight: FontWeight.bold, 
                      color: statusColor
                    ),
                  ),
                  const Text("Sisa Jarak Aman", style: TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Info Detail
            _buildInfoRow("Ganti Terakhir", "$_lastOilChangeKm KM"),
            _buildInfoRow("Odometer Saat Ini", "$_currentKm KM"),
            _buildInfoRow("Jadwal Berikutnya", "${_lastOilChangeKm + _interval} KM"),

            const Spacer(),
            
            // Tombol Update Besar
            ElevatedButton.icon(
              onPressed: () => _showUpdateDialog(context),
              icon: const Icon(Icons.speed, size: 30),
              label: const Text("UPDATE ODOMETER", style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Update KM Motor"),
        content: TextField(
          controller: _kmController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Masukkan angka odometer",
            filled: true,
            fillColor: Colors.black12,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(onPressed: _updateKm, child: const Text("Simpan", style: TextStyle(color: AppColors.primary))),
        ],
      ),
    );
  }
} 