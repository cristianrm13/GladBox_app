import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationStatusScreen extends StatefulWidget {
  const LocationStatusScreen({Key? key}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationStatusScreen> {
  String _locationMessage = "Presiona el botón para obtener tu ubicación";
  double? _latitude;
  double? _longitude;

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Permiso de ubicación denegado";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
      _locationMessage =
          "Latitud: ${_latitude}, Longitud: ${_longitude}";
    });
  }

  Future<void> _launchMapsUrl() async {
    if (_latitude == null || _longitude == null) return;
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$_latitude,$_longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'No se pudo abrir $googleMapsUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ubicacion Actual')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_locationMessage),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text('Obtener Ubicación'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _latitude != null && _longitude != null ? _launchMapsUrl : null,
              child: const Text('Ver en Mapa'),
            ),
          ],
        ),
      ),
    );
  }
}
