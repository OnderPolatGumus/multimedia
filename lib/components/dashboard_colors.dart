import 'package:flutter/material.dart';

class DashboardColors {
  // İkinci Açık Mavi
  static const Color backgroundColour2 = Color.fromARGB(255, 50, 90, 135);

  // Arka plan gradyanı: koyu lacivert → açık mavi
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A192F), // koyu lacivert-mavi
      backgroundColour2, // biraz daha açık
    ],
  );

  // Vurgu rengi (örneğin hız göstergesi)
  static const Color accentBlue = Color(0xFF48CAE4);

  // Genel metin rengi
  static const Color textWhite = Colors.white;

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
