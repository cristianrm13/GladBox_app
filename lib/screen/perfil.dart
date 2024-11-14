import 'package:GvApp/screen/editar_perfil.dart';
import 'package:GvApp/screen/extras/contact_us.dart';
import 'package:GvApp/screen/extras/politica_privacidad.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String nombre = '';
  String email = '';
  String telefono = '';

  @override
  void initState() {
    super.initState();
    obtenerDatosUsuario();
  }

  Future<void> obtenerDatosUsuario() async {
    try {
      // Obtener el userId desde SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId != null) {
        // Realizar la solicitud HTTP con el userId obtenido
        final response = await http.get(
          Uri.parse('http://192.168.1.103:3000/api/v1/usuarios/$userId'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            nombre = data['nombre'] ?? 'Nombre desconocido';
            email = data['correo'] ?? 'Email desconocido';
            telefono = data['telefono'] ?? 'Teléfono desconocido';
          });
        } else {
          throw Exception('Error al obtener los datos del usuario');
        }
      } else {
        throw Exception('userId no encontrado en SharedPreferences');
      }
    } catch (error) {
      print('Error en obtenerDatosUsuario: $error');
    }
  }

  Future<void> cerrarSesion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpiamos todos los datos guardados

    // Navegamos a la pantalla de inicio de sesión y eliminamos las rutas anteriores
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_backup_restore, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  const Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage('https://cdn-icons-png.flaticon.com/512/295/295128.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(Icons.key, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nombre,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Email: $email | Teléfono: $telefono',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit_note),
                    title: const Text('Editar información del perfil'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditarPerfil(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('Notificaciones'),
                    trailing: const Text(
                      'ON',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text('Servicios de emergencia'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Cerrar sesión'),
                    trailing: const Text(
                      'Ir',
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    onTap: cerrarSesion,
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline),
                    title: const Text('Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.contact_mail_outlined),
                    title: const Text('Contact us'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ContactUsScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PoliticaPrivacidad(),
                        ),
                      );
                    },
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
