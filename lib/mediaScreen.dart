import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui' as ui;

import 'components/car_indicators.dart';
import 'components/current_speed.dart';
import 'components/gear_battery.dart';
import 'components/time_and_temp.dart';
import 'package:intl/intl.dart';

// Utility functions for date/time formatting
String getFormattedTime() {
  return DateFormat('HH:mm:ss').format(DateTime.now());
}

String getFormattedDate() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

class VehicleData {
  final String label;
  String? value;

  VehicleData({required this.label, this.value});
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _timer;
  int _tickCounter = 0;

  // Initial vehicle data, time & date will be set in initState
  final List<VehicleData> _vehicleDataList = [
    VehicleData(label: 'Battery Voltage', value: '12.8V'),
    VehicleData(label: 'Battery Current', value: '5.2A'),
    VehicleData(label: 'Battery Temperature', value: '35°C'),
    VehicleData(label: 'Speed', value: '0 km/h'),
    VehicleData(label: 'Proximity', value: '5m'),
    VehicleData(label: 'Tire Pressure FL', value: '35 PSI'),
    VehicleData(label: 'Tire Pressure FR', value: '33 PSI'),
    VehicleData(label: 'Tire Pressure RL', value: '34 PSI'),
    VehicleData(label: 'Tire Pressure RR', value: '32 PSI'),
    VehicleData(label: 'Fuel (Wh)', value: '1500 Wh'),
    VehicleData(label: 'Fuel (kmh)', value: '0 km/h'),
    VehicleData(label: 'Time', value: getFormattedTime()),
    VehicleData(label: 'Start', value: '0 ms'),
    VehicleData(label: 'Date', value: getFormattedDate()),
  ];

  void _startPeriodicUpdates() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _tickCounter++;
        final now = DateTime.now();

        // Update time & date each tick
        _vehicleDataList[11].value = getFormattedTime();
        _vehicleDataList[13].value = getFormattedDate();

        // Simulate other metrics
        _vehicleDataList[0].value = '${(12.0 + _tickCounter * 0.01).toStringAsFixed(2)}V';
        _vehicleDataList[1].value = '${(5.0 + _tickCounter * 0.02).toStringAsFixed(2)}A';
        _vehicleDataList[2].value = '${35 + _tickCounter % 10}°C';
        final speed = 120 + _tickCounter % 10;
        _vehicleDataList[3].value = '$speed km/h';
        _vehicleDataList[9].value = '${1500 + _tickCounter * 2} Wh';
        _vehicleDataList[10].value = '${180 + _tickCounter} km/h';
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure time/date labels have initial context
      setState(() {
        _vehicleDataList[11].value = getFormattedTime();
        _vehicleDataList[13].value = getFormattedDate();
      });
      _startPeriodicUpdates();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        child: (size.width > 1184 && size.height > 604)
            ? Row(
                children: [
                  // Left panel: Ready-made dashboard UI
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      constraints: const BoxConstraints(
                        minWidth: 1184,
                        maxWidth: 1480,
                        minHeight: 456,
                        maxHeight: 604,
                      ),
                      child: AspectRatio(
                        aspectRatio: 2.59,
                        child: LayoutBuilder(
                          builder: (context, constraints) => CustomPaint(
                            painter: PathPainter(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TimeAndTemp(constraints: constraints),
                                Expanded(
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Column(
                                        children: [
                                          const SizedBox(height: 20),
                                          const CarIndicators(),
                                          const Spacer(),
                                          CurrentSpeed(
                                            speed: int.parse(
                                              _vehicleDataList[3]
                                                  .value!
                                                  .split(' ')
                                                  .first,
                                            ),
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/speed_miter.svg',
                                                height: 32,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 8),
                                                child: Text(
                                                  _vehicleDataList[3].value!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: const Color(
                                                            0xFF2438B6),
                                                      ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          GearAndBattery(
                                              constraints: constraints),
                                        ],
                                      ),
                                      // Speed lines: left and right
                                      ...List.generate(
                                        8,
                                        (index) => Positioned(
                                          bottom: 20 + 2.0 * index,
                                          left: constraints.maxWidth * 0.13 -
                                              30 * index,
                                          height: constraints.maxHeight * 0.8,
                                          width: constraints.maxWidth * 0.31,
                                          child: Opacity(
                                            opacity: 1 - index * 0.1,
                                            child: CustomPaint(
                                              painter: SpeedLinePainter(),
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...List.generate(
                                        8,
                                        (index) => Positioned(
                                          bottom: 20 + 2.0 * index,
                                          right: constraints.maxWidth * 0.13 -
                                              30 * index,
                                          height: constraints.maxHeight * 0.8,
                                          width: constraints.maxWidth * 0.31,
                                          child: Transform.scale(
                                            scaleX: -1,
                                            child: Opacity(
                                              opacity: 1 - index * 0.1,
                                              child: CustomPaint(
                                                painter: SpeedLinePainter(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Divider
                  const VerticalDivider(color: Colors.white, thickness: 1),
                  // Right panel: data list
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _vehicleDataList.map((data) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                Text(
                                  '${data.label}:',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  data.value!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: Text(
                  'The screen is too small to display the UI.\nResize the window or use a larger device.',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(size.width, size.height),
        [const Color(0xFF080A6B), const Color(0xFF280569)],
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width * 0.13, size.height * 0.05)
      ..lineTo(size.width * 0.31, 0)
      ..lineTo(size.width * 0.39, size.height * 0.11)
      ..lineTo(size.width * 0.60, size.height * 0.11)
      ..lineTo(size.width * 0.69, 0)
      ..lineTo(size.width * 0.87, size.height * 0.05)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(size.width * 0.87, size.height)
      ..lineTo(size.width * 0.13, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class SpeedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(size.width, 0),
        Offset(0, size.height),
        [const Color(0xFF0D47A1).withOpacity(1), const Color(0xFF0D47A1).withOpacity(0.8)],
      )
      ..style = PaintingStyle.fill;

    const double stroke = 8;
    final p1 = Path()
      ..moveTo(size.width * 0.76, 0)
      ..lineTo(size.width, size.height * 0.3)
      ..lineTo(size.width - stroke, size.height * 0.3)
      ..close();

    final p2 = Path()
      ..moveTo(size.width, size.height * 0.3)
      ..lineTo(40, size.height - 20)
      ..lineTo(size.width - stroke, size.height * 0.3)
      ..close();

    canvas.drawPath(p1, paint);
    canvas.drawPath(p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class GearPrinter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = const Color(0xFF52342C)
      ..style = PaintingStyle.fill;

    // paint.shader = LinearGradient(colors: colors)
    const double strokeWidth = 2;
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.17, size.height * 0.5);
    path.lineTo(size.width * 0.34, size.height * 0.5);
    path.lineTo(size.width * 0.42, 0);
    path.lineTo(size.width * 0.48, 0);
    path.lineTo(size.width * 0.48, strokeWidth);
    path.lineTo(size.width * 0.42, strokeWidth);
    path.lineTo(size.width * 0.34, size.height * 0.5 + strokeWidth);
    path.lineTo(size.width * 0.17, size.height * 0.5 + strokeWidth);
    // path.moveTo(size.width * 0.52, 0);

    path.close();
    canvas.drawPath(path, paint);

    Path path2 = Path();
    path2.moveTo(size.width * 0.52, 0);
    path2.lineTo(size.width * 0.58, 0);
    path2.lineTo(size.width * 0.66, size.height * 0.5);
    path2.lineTo(size.width * 0.83, size.height * 0.5);
    path2.lineTo(size.width, size.height);
    path2.lineTo(size.width * 0.83, size.height * 0.5 + strokeWidth);
    path2.lineTo(size.width * 0.66, size.height * 0.5 + strokeWidth);
    path2.lineTo(size.width * 0.58, strokeWidth);
    path2.lineTo(size.width * 0.52, strokeWidth);

    path2.close();
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class DashLinePainter extends CustomPainter {
  final double progress;

  DashLinePainter({required this.progress});

  final Paint _paint = Paint()
    ..color = const Color(0xFF52342C)
    ..strokeWidth = 10.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path()
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width * progress, size.height / 2);

    Path dashPath = Path();

    double dashWidth = 24.0;
    double dashSpace = 2.0;
    double distance = 0.0;

    for (ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth;
        distance += dashSpace;
      }
    }
    canvas.drawPath(dashPath, _paint);
  }

  @override
  bool shouldRepaint(DashLinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}