
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorScreen extends StatefulWidget {
  const SensorScreen({Key? key}) : super(key: key);

  @override
  _SensorScreenState createState() => _SensorScreenState();
}

class _SensorScreenState extends State<SensorScreen> {
  // Variables para almacenar los datos de los sensores
  String _accelerometer = 'Sin datos';
  String _gyroscope = 'Sin datos';
  String _magnetometer = 'Sin datos';

  @override
  void initState() {
    super.initState();
    _initSensors();
  }

  void _initSensors() {
    // Escuchar los datos del acelerómetro
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _accelerometer =
            'X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}';
      });
    });

    // Escuchar los datos del giroscopio
    gyroscopeEvents.listen((GyroscopeEvent event) {
      setState(() {
        _gyroscope =
            'X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}';
      });
    });

    // Escuchar los datos del magnetómetro
    magnetometerEvents.listen((MagnetometerEvent event) {
      setState(() {
        _magnetometer =
            'X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}, Z: ${event.z.toStringAsFixed(2)}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos de Sensores'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSensorTile('Acelerómetro', _accelerometer),
            const SizedBox(height: 20),
            _buildSensorTile('Giroscopio', _gyroscope),
            const SizedBox(height: 20),
            _buildSensorTile('Magnetómetro', _magnetometer),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorTile(String sensorName, String sensorData) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sensorName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              sensorData,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}