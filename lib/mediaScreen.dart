import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class VehicleData {
  final String label;
  String? value;

  VehicleData({required this.label, this.value});
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

int timervar = 0;

String getFormattedTime() {
  DateTime now = DateTime.now();
  return DateFormat('HH:mm:ss').format(now);
}

String getFormattedDate() {
  DateTime now = DateTime.now();
  return DateFormat('yyyy-MM-dd').format(now);
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<VehicleData> vehicleDataList = [
    VehicleData(label: 'Battery Voltage', value: '12.8V'),
    VehicleData(label: 'Battery Current', value: '5.2A'),
    VehicleData(label: 'Battery Temperature', value: '35°C'),
    VehicleData(label: 'Speed', value: '120 km/h'),
    VehicleData(label: 'Proximity', value: '5m'),
    VehicleData(label: 'Tire Pressure FL', value: '35 PSI'),
    VehicleData(label: 'Tire Pressure FR', value: '33 PSI'),
    VehicleData(label: 'Tire Pressure RL', value: '34 PSI'),
    VehicleData(label: 'Tire Pressure RR', value: '32 PSI'),
    VehicleData(label: 'Fuel (Wh)', value: '1500 Wh'),
    VehicleData(label: 'Fuel (kmh)', value: '180 km/h'),
    VehicleData(label: 'Time', value: '12:30 PM'),
    VehicleData(label: 'Start', value: '0 ms'),
    VehicleData(label: 'Date', value: '2024-12-30'),
  ];

  String batteryVoltage = '0';
  String batteryCurrent = '0';
  String speed = '0';
  String fuelWh = '0';
  String fuelkmh = '0';
  String time = '0';
  String date = '0';
  String Btemp = '0';

  late Timer _timer;

  void updateValue(int index, String newValue) {
    setState(() {
      vehicleDataList[index].value = newValue;
    });
  }

  void startPeriodicUpdates() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        timervar += 100;
        updateValue(0, '${(12.0 + (timer.tick * 0.01)).toStringAsFixed(2)}V');
        updateValue(1, '${(5.0 + (timer.tick * 0.02)).toStringAsFixed(2)}A');
        updateValue(2, '${(35 + timer.tick % 10)}°C');
        updateValue(3, '${(120 + timer.tick % 10)} km/h');
        updateValue(4, '${(5 + timer.tick % 2)}m');
        updateValue(5, '${(35 + timer.tick % 5)} PSI');
        updateValue(6, '${(33 + timer.tick % 5)} PSI');
        updateValue(7, '${(34 + timer.tick % 5)} PSI');
        updateValue(8, '${(32 + timer.tick % 5)} PSI');
        updateValue(9, '${(1500 + timer.tick * 2)} Wh');
        updateValue(10, '${(180 + timer.tick)} km/h');
        updateValue(11, getFormattedTime());
        updateValue(12, '${(timervar / 10)}ms');
        updateValue(13, getFormattedDate());

        Btemp = vehicleDataList[2].value ?? '0';
        time = vehicleDataList[12].value ?? '0';
        speed = vehicleDataList[3].value ?? '0';
        fuelWh = vehicleDataList[9].value ?? '0';
        fuelkmh = vehicleDataList[10].value ?? '0';
        batteryCurrent = vehicleDataList[1].value ?? '0';
        batteryVoltage = vehicleDataList[0].value ?? '0';
        date = vehicleDataList[13].value ?? '0';
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startPeriodicUpdates();
    });
  }

  double parseSpeed(String rawSpeed) {
    return double.tryParse(rawSpeed.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFFB3B6B7),
              Color(0xFF5D6D7E),
              Color(0xFF2E3B4E),
              Color(0xFF5D6D7E),
              Color(0xFFB3B6B7),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Date : $date", style: TextStyle(fontSize: 22, color: Colors.white)),
                        Text("Time: $time", style: TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(height: 20),
                        SizedBox(
                          height: 300,
                          width: 300,
                          child: SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 240,
                                ranges: <GaugeRange>[
                                  GaugeRange(startValue: 0, endValue: 120, color: Colors.green),
                                  GaugeRange(startValue: 120, endValue: 180, color: Colors.orange),
                                  GaugeRange(startValue: 180, endValue: 240, color: Colors.red),
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(value: parseSpeed(speed))
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Text(
                                      speed,
                                      style: TextStyle(fontSize: 22, color: Colors.white),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.75,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Speed: $speed", style: TextStyle(fontSize: 20, color: Colors.white)),
                        SizedBox(height: 30),
                        Text("Fuel (Km): $fuelkmh", style: TextStyle(fontSize: 14, color: Colors.white)),
                        Text("Fuel (Wh): $fuelWh", style: TextStyle(fontSize: 14, color: Colors.white)),
                        Text("Battery Voltage: $batteryVoltage", style: TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(color: Colors.white, thickness: 1),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: vehicleDataList.map((data) {
                        return Row(
                          children: [
                            Text(
                              data.label,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              data.value ?? '0',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
