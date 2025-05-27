import 'package:flutter/material.dart';

class DashboardColors {
  // Arka plan gradyanı: koyu mavi -> açık mavi
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0A192F), // koyu lacivert-mavi
      Color(0xFF1E3A5F), // biraz daha açık
    ],
  );

  // Vurgu rengi (örneğin hız göstergesi)
  static const Color accentBlue = Color(0xFF48CAE4); // açık mavi

  // Genel metin rengi
  static const Color textWhite = Colors.white;

  // Düğme arka plan rengi
  static const Color buttonBackground = Color(0xFF1B263B); // koyu mavi

  // CustomPainter için gradient renkleri (path)
  static const List<Color> pathGradient = [
    Color(0xFF1E3A5F),
    Color(0xFF3C7FA6),
  ];

  // Hız çizgisi gradyanı (tek tonlu açık mavi)
  static const List<Color> speedLineGradient = [
    Color(0xFF48CAE4),
    Color(0xFF48CAE4),
  ];

  // Vites dolgu rengi
  static const Color gearFill = Color(0xFF3C7FA6); // mavi

  // Kırık çizgi rengi
  static const Color dashLine = Color(0xFF48CAE4); // açık mavi
}
