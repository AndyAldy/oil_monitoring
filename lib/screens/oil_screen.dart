import 'package:flutter/material.dart';
import '../constants.dart';

class OilScreen extends StatefulWidget {
  const OilScreen({super.key});

  @override
  State<OilScreen> createState() => _OilScreenState();
}

class _OilScreenState extends State<OilScreen> {
  final TextEditingController _kmController = TextEditingController();
  
  // --- DATA ODOMETER UTAMA ---
  int _currentKm = 12500;

  // --- DATA OLI MESIN ---
  int _lastEngineOilChangeKm = 10000; 
  int _engineOilInterval = 2000;      
  bool _isEngineLocked = false; // Status kunci edit manual

  // --- DATA OLI GARDAN ---
  int _lastGearOilChangeKm = 8000;    
  int _gearOilInterval = 6000;        
  bool _isGearLocked = false; // Status kunci edit manual

  // Getter Sisa Jarak
  int get _remainingEngineKm => (_lastEngineOilChangeKm + _engineOilInterval) - _currentKm;
  int get _remainingGearKm => (_lastGearOilChangeKm + _gearOilInterval) - _currentKm;

  // 1. Fungsi Update Odometer (Harian)
  void _updateOdometer() {
    if (_kmController.text.isNotEmpty) {
      setState(() {
        _currentKm = int.parse(_kmController.text);
      });
      _kmController.clear();
      Navigator.pop(context);
    }
  }

  // 2. Fungsi Reset Service (Dan Kunci Edit Manual)
  void _resetService(String type) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text("Konfirmasi Ganti $type"),
        content: Text(
          "Apakah Anda baru saja mengganti $type?\n\nData akan diupdate ke $_currentKm KM dan fitur edit manual akan dikunci untuk menjaga akurasi.",
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              setState(() {
                if (type == "Oli Mesin") {
                  _lastEngineOilChangeKm = _currentKm;
                  _isEngineLocked = true; // KUNCI FITUR MANUAL
                } else {
                  _lastGearOilChangeKm = _currentKm;
                  _isGearLocked = true;   // KUNCI FITUR MANUAL
                }
              });
              Navigator.pop(context);
            }, 
            child: const Text("Ya, Sudah Ganti", style: TextStyle(color: AppColors.primary))
          ),
        ],
      )
    );
  }

  // 3. Fungsi Edit Manual (Hanya muncul di awal)
  void _showManualEditDialog(String title, int currentValue, Function(int) onSave) {
    _kmController.text = currentValue.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text("Set Awal $title"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Masukkan KM servis terakhir Anda.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.black12,
                suffixText: "KM",
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _kmController.clear();
              Navigator.pop(context);
            },
            child: const Text("Batal")
          ),
          TextButton(
            onPressed: () {
              if (_kmController.text.isNotEmpty) {
                onSave(int.parse(_kmController.text));
                _kmController.clear();
                Navigator.pop(context);
              }
            }, 
            child: const Text("Simpan", style: TextStyle(color: AppColors.primary))
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MONITORING OLI")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            // ODOMETER UTAMA
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("ODOMETER SAAT INI", style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text("$_currentKm KM", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      _kmController.clear();
                      _showUpdateDialog(context);
                    },
                    icon: const Icon(Icons.edit, color: AppColors.primary),
                    style: IconButton.styleFrom(backgroundColor: Colors.white10),
                  )
                ],
              ),
            ),

            // KARTU OLI MESIN
            _buildOilCard(
              title: "OLI MESIN",
              icon: Icons.oil_barrel,
              remainingKm: _remainingEngineKm,
              lastChange: _lastEngineOilChangeKm,
              interval: _engineOilInterval,
              isLocked: _isEngineLocked, // Cek status kunci
              onReset: () => _resetService("Oli Mesin"),
              onEditLastChange: () {
                _showManualEditDialog("Ganti Terakhir (Mesin)", _lastEngineOilChangeKm, (val) {
                  setState(() => _lastEngineOilChangeKm = val);
                });
              },
            ),

            const SizedBox(height: 20),

            // KARTU OLI GARDAN
            _buildOilCard(
              title: "OLI GARDAN",
              icon: Icons.settings_suggest,
              remainingKm: _remainingGearKm,
              lastChange: _lastGearOilChangeKm,
              interval: _gearOilInterval,
              isLocked: _isGearLocked, // Cek status kunci
              onReset: () => _resetService("Oli Gardan"),
              onEditLastChange: () {
                _showManualEditDialog("Ganti Terakhir (Gardan)", _lastGearOilChangeKm, (val) {
                  setState(() => _lastGearOilChangeKm = val);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOilCard({
    required String title,
    required IconData icon,
    required int remainingKm,
    required int lastChange,
    required int interval,
    required bool isLocked, // Parameter baru
    required VoidCallback onReset,
    required VoidCallback onEditLastChange,
  }) {
    Color statusColor = remainingKm < 500 ? AppColors.primary : Colors.green;
    String statusText = remainingKm < 0 
        ? "TERLAMBAT ${remainingKm.abs()} KM" 
        : "Sisa $remainingKm KM lagi";

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.5), width: 2),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(statusText, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logika: Jika isLocked = true, maka isEditable = false
              _buildMiniInfo(
                "Ganti Terakhir", 
                "$lastChange KM", 
                isEditable: !isLocked, 
                onTap: onEditLastChange
              ),
              _buildMiniInfo("Interval", "$interval KM"),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onReset,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white10,
                foregroundColor: statusColor,
              ),
              child: const Text("SUDAH GANTI BARU (RESET)"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMiniInfo(String label, String value, {bool isEditable = false, VoidCallback? onTap}) {
    return GestureDetector(
      // Jika tidak editable, onTap jadi null (tidak bisa diklik)
      onTap: isEditable ? onTap : null,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                // Ikon pensil hanya muncul jika isEditable = true
                if (isEditable) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.edit, size: 12, color: AppColors.primary),
                ]
              ],
            ),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 14, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text("Update Odometer"),
        content: TextField(
          controller: _kmController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Masukkan KM di speedometer",
            filled: true,
            fillColor: Colors.black12,
            suffixText: "KM"
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          TextButton(onPressed: _updateOdometer, child: const Text("Update", style: TextStyle(color: AppColors.primary))),
        ],
      ),
    );
  }
}