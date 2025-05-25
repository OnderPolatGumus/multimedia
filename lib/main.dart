import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_size/window_size.dart';

import 'mediaScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Vehicle Dashboard');

    // Pencereyi sabitle: 3200x600
    const size = Size(3200, 600);
    setWindowMinSize(size);
    setWindowMaxSize(size);
    setWindowFrame(Rect.fromLTWH(
        100, 100, size.width, size.height)); // Ekranda konum + boyut
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
