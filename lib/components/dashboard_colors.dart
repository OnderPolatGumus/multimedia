import 'package:flutter/material.dart';

class DashboardColors {
  // İkinci Açık Mavi
  static const Color backgroundColour2 = Color.fromARGB(255, 50, 90, 135);

  // Genel metin rengi
  static const Color textWhite = Colors.white;

  // Hafif opak beyazlar
  static const Color textWhite38 = Colors.white38;
  static const Color textWhite24 = Colors.white24;
  static const Color textWhite54 = Colors.white54;
  static const Color textPure = Color(0xFFFFFFFF);

  // AvgWatt ve Odo kutuları için zemin rengi
  static const Color avgWattPerKmPrinterColor = Color(0xFF325A87);

  // Arka plan gradyanı: koyu lacivert → açık mavi
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A192F), // koyu lacivert-mavi
      Color(0xFF325A87), // biraz daha açık
    ],
  );

  // Vurgu rengi (örneğin hız göstergesi)
  static const Color accentBlue = Color(0xFF48CAE4);

  // Pasif metin rengi (örneğin seçili olmayan vites)
  static const Color inactiveText = Colors.white10;

  // “km/h” birim metni rengi
  static const Color speedUnitColor = Colors.white30;

  // Hız sayısı (CurrentSpeed) için ShaderMask gradyanı
  static const List<Color> speedTextGradient = [
    textWhite,
    textWhite,
  ];

  // Düğme arka plan rengi
  static const Color buttonBackground = Color(0xFF1B263B);

  // PathPainter gradyanı
  static const List<Color> pathGradient = [
    Color(0xFF1E3A5F),
    Color(0xFF3C7FA6),
  ];

  // SpeedLinePainter gradyanı
  static const List<Color> speedLineGradient = [
    accentBlue,
    accentBlue,
  ];

  // GearPrinter dolgu rengi
  static const Color gearFill = Color(0xFF3C7FA6);

  // DashLinePainter rengi
  static const Color dashLine = accentBlue;

  // Bluetooth Classic arka plan renkleri
  static const Color blcBackground1 = Color(0xFF1E395A);
  static const Color blcBackground2 = backgroundColour2;
}
