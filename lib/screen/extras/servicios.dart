import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiciosEmergenciasScreen extends StatelessWidget {
  const ServiciosEmergenciasScreen({super.key});

  Future<void> _launchCaller(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunch(url.toString())) {
        await launch(url.toString());
      } else {
        throw 'No se pudo realizar la llamada';
      }
    } catch (e) {
      print('Error al intentar realizar la llamada: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriasPorCorreo = {
      'cristianrmartist@gmail.com': {
        'categorias': ['alumbrado'],
        'telefono': '123-456-7890'
      },
      '221267@ids.upchiapas.edu.mx': {
        'categorias': ['limpieza'],
        'telefono': '098-765-4321'
      },
      'cristiangv1313@gmail.com': {
        'categorias': ['baches'],
        'telefono': '567-890-1234'
      },
      'perrera@example.com': {
        'categorias': ['seguridad'],
        'telefono': '234-567-8901'
      },
      'bomber@example.com': {
        'categorias': ['alumbrado', 'seguridad'],
        'telefono': '345-678-9012'
      },
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios de Emergencias'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: categoriasPorCorreo.entries.map((entry) {
            return Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.teal),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Text(
                            'Correo: ${entry.key}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.teal[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Categorías: ${(entry.value['categorias'] as List<String>).join(', ')}',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.blueAccent),
                        const SizedBox(width: 8.0),
                        Text(
                          'Teléfono: ${entry.value['telefono'] as String}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.call),
                          color: Colors.green,
                          onPressed: () => _launchCaller(entry.value['telefono'] as String),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
