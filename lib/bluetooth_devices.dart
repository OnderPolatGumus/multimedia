import 'package:flutter/material.dart';
import '../components/dashboard_colors.dart';
import 'dart:io';

class BluetoothDevice {
  final String name;
  final String macAddress;
  bool isConnected;
  BluetoothDevice({
    required this.name,
    required this.macAddress,
    this.isConnected = false,
  });
}

Future<List<BluetoothDevice>> fetchBluetoothDevices() async {
  final result = await Process.run('bluetoothctl', ['devices']);
  final connectedResult = await Process.run('bluetoothctl', ['info']);

  final connectedMacs = <String>{};
  if (connectedResult.exitCode == 0) {
    final lines = connectedResult.stdout.toString().split('\n');
    for (var line in lines) {
      if (line.trim().startsWith('Device')) {
        final parts = line.split(' ');
        if (parts.length > 1) {
          connectedMacs.add(parts[1]);
        }
      }
    }
  }

  if (result.exitCode != 0) return [];

  final lines = result.stdout.toString().split('\n');
  return lines.where((line) => line.startsWith('Device')).map((line) {
    final parts = line.split(' ');
    final mac = parts[1];
    final name = parts.sublist(2).join(' ');
    final isConnected = connectedMacs.contains(mac);
    return BluetoothDevice(name: name, macAddress: mac, isConnected: isConnected);
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

  Future<void> _toggleConnection(BluetoothDevice device) async {
    final cmd = device.isConnected
        ? ['disconnect', device.macAddress]
        : ['connect', device.macAddress];

    await Process.run('bluetoothctl', cmd);
    setState(() {
      _deviceFuture = fetchBluetoothDevices();
    });
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
                      leading: Icon(
                        Icons.bluetooth,
                        color: device.isConnected ? Colors.green : Colors.blue,
                      ),
                      trailing: TextButton(
                        onPressed: () => _toggleConnection(device),
                        child: Text(
                          device.isConnected ? 'Bağlantıyı Kes' : 'Bağlan',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
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
