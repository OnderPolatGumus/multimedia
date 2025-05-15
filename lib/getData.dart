class VehicleData {
  final String label;
  final String value;

  VehicleData({required this.label, required this.value});
}

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
  VehicleData(label: 'Start', value: '08:00 AM'),
  VehicleData(label: 'Date', value: '2024-12-30'),
];
