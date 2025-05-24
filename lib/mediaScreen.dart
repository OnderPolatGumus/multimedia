import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../painterClasses.dart';
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
        _vehicleDataList[0].value =
            '${(12.0 + _tickCounter * 0.01).toStringAsFixed(2)}V';
        _vehicleDataList[1].value =
            '${(5.0 + _tickCounter * 0.02).toStringAsFixed(2)}A';
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
                                                padding: const EdgeInsets.only(
                                                    left: 8),
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
                            padding: const EdgeInsets.symmetric(vertical: 4),
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
