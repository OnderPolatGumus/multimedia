import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';
import 'package:window_manager/window_manager.dart';

import 'mediaScreen.dart'; // DashboardScreen(role: 'left' | 'right' | 'both')

// Tam ekranı aç/kapat togglesı (istersen false yapıp pencere moduna dönebilirsin)
const bool kFullscreen = true;

// Belirli monitöre yerleştirme (soldaki/sağdaki)
Future<Rect?> _computeTargetFrame({
  required String role, // 'left' | 'right'
  Size winSize = const Size(1600, 600),
}) async {
  final screens = await getScreenList();
  if (screens.isEmpty) return null;

  // soldaki ve sağdaki ekranı x konumuna göre bul
  Screen leftMost = screens.first;
  Screen rightMost = screens.first;
  for (final s in screens) {
    if (s.frame.left < leftMost.frame.left) leftMost = s;
    if (s.frame.left > rightMost.frame.left) rightMost = s;
  }
  final target = (role == 'left') ? leftMost : rightMost;

  if (kFullscreen) {
    // Tam ekran: hedef ekranın görünür alanını kapla
    final vf = target.visibleFrame;
    return Rect.fromLTWH(vf.left, vf.top, vf.width, vf.height);
  } else {
    // Pencere modu: hedef ekranda ortala
    const win = Size(1600, 600);
    final vf = target.visibleFrame;
    final dx = vf.left + (vf.width - win.width) / 2;
    final dy = vf.top + (vf.height - win.height) / 2;
    return Rect.fromLTWH(dx, dy, win.width, win.height);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ROL: ENV > --dart-define > 'left'
  final roleEnv = Platform.environment['APP_ROLE'];
  const roleDefine = String.fromEnvironment('APP_ROLE', defaultValue: '');
  final role = (roleEnv != null && roleEnv.isNotEmpty)
      ? roleEnv
      : (roleDefine.isNotEmpty ? roleDefine : 'left'); // 'left' | 'right' | 'both'

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    // window_manager hazırlığı
    await windowManager.ensureInitialized();

    // (İsteğe bağlı) pencere başlığı/arka plan opsiyonları
    const opts = WindowOptions(
      titleBarStyle: TitleBarStyle.hidden,   // başlık çubuğunu gizler
      backgroundColor: Colors.transparent,   // arka planı transparan
    );

    windowManager.waitUntilReadyToShow(opts, () async {
      // Hedef ekran çerçevesini hesapla ve pencereyi oraya taşı
      final frame = await _computeTargetFrame(role: role);
      if (frame != null) {
        // window_size ile taşıma yerine window_manager.setBounds da kullanılabilir
        // ama window_size zaten kurulu: her ikisi de çalışır.
        await windowManager.setBounds(frame);
      }

      // Başlık
      await windowManager.setTitle('Vehicle Dashboard — ${role.toUpperCase()}');

      // Tam ekranı aç
      if (kFullscreen) {
        await windowManager.setFullScreen(true);
      }

      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(MyApp(role: role));
}

class MyApp extends StatelessWidget {
  final String role; // 'left' | 'right' | 'both'
  const MyApp({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Colors.transparent,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: DashboardScreen(role: role),
    );
  }
}
