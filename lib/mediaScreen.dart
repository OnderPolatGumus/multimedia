import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

import '../painterClasses.dart';
import '../components/dashboard_colors.dart';
import 'components/car_indicators.dart';
import 'components/current_speed.dart';
import 'components/gear_battery.dart';
import 'components/time_and_temp.dart';
import 'bluetooth_devices.dart';
import 'map_view.dart';

String getFormattedTime() => DateFormat('HH:mm:ss').format(DateTime.now());
String getFormattedDate() => DateFormat('yyyy-MM-dd').format(DateTime.now());

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
  bool _showMap = false;
  bool _isMapLoading = false;
  bool _showBluetoothList = false;

  final List<VehicleData> _vehicleDataList = [
    VehicleData(label: 'Battery Voltage', value: '12.8V'), //0
    VehicleData(label: 'Battery Current', value: '5.2A'),
    VehicleData(label: 'Battery Temperature', value: '35°C'),
    VehicleData(label: 'Speed', value: '0 km/h'),
    VehicleData(label: 'Proximity', value: '5m'),
    VehicleData(label: 'Tire Pressure FL', value: '35 PSI'), //5
    VehicleData(label: 'Tire Pressure FR', value: '33 PSI'),
    VehicleData(label: 'Tire Pressure RL', value: '34 PSI'),
    VehicleData(label: 'Tire Pressure RR', value: '32 PSI'),
    VehicleData(label: 'Fuel (Wh)', value: '1500 Wh'),
    VehicleData(label: 'Fuel (km/h)', value: '0 km'), //10
    VehicleData(label: 'Time', value: getFormattedTime()),
    VehicleData(label: 'Start', value: '0 ms'),
    VehicleData(label: 'Date', value: getFormattedDate()),
  ];

  //simulation later will be real data
  void _startPeriodicUpdates() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      setState(() {
        _tickCounter++;
        // Battery Voltage
        _vehicleDataList[0].value =
            '${(12.0 + _tickCounter * 0.01).toStringAsFixed(2)}V';
        // Battery Current
        _vehicleDataList[1].value =
            '${(5.0 + _tickCounter * 0.02).toStringAsFixed(2)}A';
        // Battery Temperature
        _vehicleDataList[2].value = '${35 + _tickCounter % 10}°C';
        // Speed
        final speed = 120 + _tickCounter % 10;
        _vehicleDataList[3].value = '$speed km/h';
        // Proximity
        _vehicleDataList[4].value = '${5 + _tickCounter % 10}m';
        //Tire Pressure FR
        _vehicleDataList[5].value = '${35 + _tickCounter % 10}psi';
        //Tire Pressure FL
        _vehicleDataList[6].value = '${33 + _tickCounter % 10}psi';
        //Tire Pressure RL
        _vehicleDataList[7].value = '${34 + _tickCounter % 10}psi';
        //Tire Pressure RR
        _vehicleDataList[8].value = '${32 + _tickCounter % 10}psi';
        //Fuel WH
        _vehicleDataList[9].value = '${1500 + _tickCounter * 2} Wh';
        //Fuel km
        _vehicleDataList[10].value = '${180 + _tickCounter} km';
        //Time
        _vehicleDataList[11].value = getFormattedTime();
        //Elapsed Time
        _vehicleDataList[12].value =
            '${(int.tryParse(_vehicleDataList[12].value ?? '0') ?? 0) + 1}';
        //Date
        _vehicleDataList[13].value = getFormattedDate();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: DashboardColors.backgroundGradient,
        ),
        child: Row(
          children: [
            // Sol panel: Dashboard
            Expanded(
              flex: 1,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 1280,
                        minHeight: 480,
                        maxWidth: 1600,
                        maxHeight: 600,
                      ),
                      child: SizedBox(
                        width: 1280,
                        height: 480,
                        child: AspectRatio(
                          aspectRatio: 2.59,
                          child: LayoutBuilder(
                            builder: (context, constraints) => CustomPaint(
                              painter: PathPainter(),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TimeAndTemp(
                                    constraints: constraints,
                                    time: _vehicleDataList[11].value!,
                                    temperature: _vehicleDataList[2].value!,
                                  ),
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
                                                _vehicleDataList[3]!
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
                                                const SizedBox(width: 8),
                                                Text(
                                                  _vehicleDataList[3]!.value!,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .copyWith(
                                                        color: DashboardColors
                                                            .accentBlue,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            GearAndBattery(
                                                constraints: constraints),
                                          ],
                                        ),
                                        ...List.generate(
                                          8,
                                          (i) => Positioned(
                                            bottom: 20.0 + 2.0 * i,
                                            left: constraints.maxWidth * 0.13 -
                                                30 * i,
                                            height: constraints.maxHeight * 0.8,
                                            width: constraints.maxWidth * 0.31,
                                            child: Opacity(
                                              opacity: 1.0 - i * 0.1,
                                              child: CustomPaint(
                                                painter: SpeedLinePainter(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        ...List.generate(
                                          8,
                                          (i) => Positioned(
                                            bottom: 20.0 + 2.0 * i,
                                            right: constraints.maxWidth * 0.13 -
                                                30.0 * i,
                                            height: constraints.maxHeight * 0.8,
                                            width: constraints.maxWidth * 0.31,
                                            child: Transform.scale(
                                              scaleX: -1,
                                              child: Opacity(
                                                opacity: 1 - i * 0.1,
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
                  ),
                ),
              ),
            ),

            const VerticalDivider(
              color: DashboardColors.textWhite,
              thickness: 1,
            ),

            // Sağ panel: Map / Bluetooth / Data
            Expanded(
              flex: 1,
              child: _showMap
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: MapviewScreen(
                            onExit: () => setState(() => _showMap = false),
                            onMapReady: () =>
                                setState(() => _isMapLoading = false),
                          ),
                        ),
                        if (_isMapLoading)
                          const Center(child: CupertinoActivityIndicator()),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: ElevatedButton.icon(
                            onPressed: () => setState(() => _showMap = false),
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Geri'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: DashboardColors.buttonBackground,
                              foregroundColor: DashboardColors.textWhite,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : _showBluetoothList
                      ? BluetoothListWidget(
                          onExit: () =>
                              setState(() => _showBluetoothList = false),
                        )
                      : Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: ListView(
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
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () => setState(
                                        () => _showBluetoothList = true),
                                    icon: const Icon(Icons.bluetooth,
                                        color: Colors.white),
                                    tooltip: 'Bluetooth',
                                    iconSize: 32,
                                  ),
                                  const SizedBox(width: 10),
                                  IconButton(
                                    onPressed: () => setState(() {
                                      _isMapLoading = true;
                                      _showMap = true;
                                    }),
                                    icon: const Icon(Icons.map,
                                        color: Colors.white),
                                    tooltip: 'Haritayı Göster',
                                    iconSize: 32,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
