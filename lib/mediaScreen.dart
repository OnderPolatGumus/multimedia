import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// 📝 Function 1: Create a .txt file and write the first line
Future<String> createFileWithLine(String fileName, String firstLine) async {
  try {
    // Ensure the file has a .txt extension
    if (!fileName.endsWith('.txt')) {
      fileName += '.txt';
    }

    // Sanitize the file name (replace spaces and special characters)
    String sanitizedFileName = fileName.replaceAll(RegExp(r'[^\w\-_.]'), '_');

    // Get the home directory for Linux
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$sanitizedFileName';

    File file = File(filePath);

    if (!await file.exists()) {
      await file.create(); // Create the file if it doesn't exist
      await file.writeAsString('$firstLine\n');
      return 'File created and written at: $filePath';
    } else {
      return 'File already exists at: $filePath';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

/// 📝 Function 2: Append a new line to an existing .txt file
Future<String> appendLineToFile(String fileName, String newLine) async {
  try {
    // Ensure the file has a .txt extension
    if (!fileName.endsWith('.txt')) {
      fileName += '.txt';
    }

    // Sanitize the file name (replace spaces and special characters)
    String sanitizedFileName = fileName.replaceAll(RegExp(r'[^\w\-_.]'), '_');

    // Get the home directory for Linux
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = '${directory.path}/$sanitizedFileName';

    File file = File(filePath);

    if (await file.exists()) {
      await file.writeAsString('$newLine\n', mode: FileMode.append);
      return 'Line appended to file: $filePath';
    } else {
      return 'File does not exist. Please create it first.';
    }
  } catch (e) {
    return 'Error: $e';
  }
}

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

  String formattedTime = DateFormat('HH:mm:ss').format(now);

  return formattedTime;
}

String getFormattedDate() {
  DateTime now = DateTime.now();

  String formattedDate = DateFormat('yyyy-MM-dd').format(now);

  return formattedDate;
}

String deviceDate = getFormattedDate();
String deviceTime = getFormattedTime();

class _DashboardScreenState extends State<DashboardScreen> {
  // List of VehicleData instances
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
    VehicleData(label: 'Start', value: '$timervar ms'),
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

  // Timer variable
  late Timer _timer;

  // Function to update values dynamically
  void updateValue(int index, String newValue) {
    setState(() {
      vehicleDataList[index].value = newValue;
    });
  }

  // Method to simulate data update every 0.1 seconds
  void startPeriodicUpdates() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timervar += 100;
        // Update each value based on simulated data CHANGE THIS FOR GETTING DATA
        updateValue(0,
            '${(12.0 + (timer.tick * 0.01)).toStringAsFixed(2)}V'); // Update Battery Voltage
        updateValue(1,
            '${(5.0 + (timer.tick * 0.02)).toStringAsFixed(2)}A'); // Update Battery Current
        updateValue(
            2, '${(35 + timer.tick % 10)}°C'); // Update Battery Temperature
        updateValue(3, '${(120 + timer.tick % 10)} km/h'); // Update Speed
        updateValue(4, '${(5 + timer.tick % 2)}m'); // Update Proximity
        updateValue(
            5, '${(35 + timer.tick % 5)} PSI'); // Update Tire Pressure FL
        updateValue(
            6, '${(33 + timer.tick % 5)} PSI'); // Update Tire Pressure FR
        updateValue(
            7, '${(34 + timer.tick % 5)} PSI'); // Update Tire Pressure RL
        updateValue(
            8, '${(32 + timer.tick % 5)} PSI'); // Update Tire Pressure RR
        updateValue(9, '${(1500 + timer.tick * 2)} Wh'); // Update Fuel (Wh)
        updateValue(10, '${(180 + timer.tick)} km/h'); // Update Fuel (kmh)
        updateValue(11, getFormattedTime()); // Update Time
        updateValue(
            12, '${(timervar / 10)}ms'); // Keeping Start fixed for simplicity
        updateValue(
            13, getFormattedDate()); // Keeping Date fixed for simplicity

        //for left screen
        Btemp = vehicleDataList[2].value ?? '0';
        time = vehicleDataList[12].value ?? '0';
        speed = vehicleDataList[3].value ?? '0';
        fuelWh = vehicleDataList[9].value ?? '0';
        fuelkmh = vehicleDataList[10].value ?? '0';
        batteryCurrent = vehicleDataList[1].value ?? '0';
        batteryVoltage = vehicleDataList[0].value ?? '0';
        date = vehicleDataList[13].value ?? '0';

        //updatelog
        appendLineToFile("log_${deviceDate}_$deviceTime",
            "$time __$speed __$Btemp __$batteryVoltage __$batteryCurrent");
      });
    });
  }

  // Cancel the timer when the widget is disposed
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createFileWithLine(
        "log_${deviceDate}_$deviceTime", "logstart");
    // Start the periodic updates when the screen is initialized
    startPeriodicUpdates();
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color.fromARGB(255, 37, 37, 37)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                // Left side layout
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Date : $date",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Time: $time',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 50),
                        Text(speed,
                            style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(height: 50),
                        Text('Fuel (Km): $fuelkmh',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Fuel (Wh): $fuelWh',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text('Battery Voltage: $batteryVoltage',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(color: Colors.white, thickness: 1),
                // Right side layout with dynamic updates
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: vehicleDataList.map((data) {
                        return Row(
                          children: [
                            Text(data.label,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(width: 10),
                            Text(
                              data.value ?? '0', // Use '0' if value is null
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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
