import 'package:flutter/material.dart';
import '../components/dashboard_colors.dart';
import 'dart:io';

class BluetoothDevice {
  final String name;
  final String macAddress;
  BluetoothDevice({required this.name, required this.macAddress});
}

Future<List<BluetoothDevice>> fetchBluetoothDevices() async {
  final result = await Process.run('bluetoothctl', ['devices']);
  if (result.exitCode != 0) return [];

  final lines = result.stdout.toString().split('\n');
  return lines.where((line) => line.startsWith('Device')).map((line) {
    final parts = line.split(' ');
    final mac = parts[1];
    final name = parts.sublist(2).join(' ');
    return BluetoothDevice(name: name, macAddress: mac);
  }).toList();
}

class BluetoothListWidget extends StatefulWidget {
  final VoidCallback onExit;
  const BluetoothListWidget({super.key, required this.onExit});

  @override
  State<BluetoothListWidget> createState() => _BluetoothListWidgetState();
}

class _BluetoothListWidgetState extends State<BluetoothListWidget> {
  late Future<List<BluetoothDevice>> _deviceFuture;

  @override
  void initState() {
    super.initState();
    _deviceFuture = fetchBluetoothDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              DashboardColors.blcBackground1,
              DashboardColors.blcBackground2
            ]),
          ),
          child: FutureBuilder<List<BluetoothDevice>>(
            future: _deviceFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(
                    child: Text('Hata oluştu',
                        style: TextStyle(color: Colors.white)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('Cihaz bulunamadı',
                        style: TextStyle(color: Colors.white)));
              } else {
                final devices = snapshot.data!;
                return ListView.builder(
                  itemCount: devices.length,
                  itemBuilder: (context, index) {
                    final device = devices[index];
                    return ListTile(
                      title: Text(device.name,
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Text(device.macAddress,
                          style: const TextStyle(color: Colors.grey)),
                      leading: const Icon(Icons.bluetooth, color: Colors.blue),
                      onTap: () {
                        // Bağlantı kurulabilir (ileride eklenecek)
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: ElevatedButton.icon(
            onPressed: widget.onExit,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Geri'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.7),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
