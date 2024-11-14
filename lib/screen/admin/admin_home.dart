// home.dart
import 'dart:convert';
import 'package:GvApp/screen/admin/graficas.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:GvApp/screen/location_status.dart';
import 'package:GvApp/screen/notificaciones.dart';
import 'package:GvApp/screen/perfil.dart';
//import 'package:GvApp/screen/formularioReporte.dart';
import 'package:GvApp/screen/extras/ad_banner.dart'; // Importa el widget del anuncio

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});


  Future<List<dynamic>> fetchQuejas() async {
    final url = Uri.parse('http://192.168.1.103:3000/api/v1/quejas/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al obtener quejas: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/Gladbox.png'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportesView()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PerfilScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.pin_drop_sharp),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LocationStatusScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/USER.jpg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '¿Qué estás pensando?',
                      fillColor: Colors.green[100],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: fetchQuejas(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final quejas = snapshot.data ?? [];
                  return ListView.builder(
                    itemCount: quejas.length,
                    itemBuilder: (context, index) {
                      final queja = quejas[index];
                      return _buildPostCard(queja);
                    },
                  );
                }
              },
            ),
          ),
          // Widget del anuncio en la parte inferior
          AdBanner(),
        ],
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> queja) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/USER.jpg'),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usuario Anónimo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      queja['dateCreated'] ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              queja['title'] ?? 'Sin título',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              queja['description'] ?? 'Sin descripción',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Categoría: ${queja['category']}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            Text(
              'Estatus: ${queja['status']}',
              style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/Gladbox.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                Icon(Icons.thumb_up, color: Colors.blue),
                SizedBox(width: 5),
                Text('1,964'),
                SizedBox(width: 20),
                Icon(Icons.comment, color: Colors.grey),
                SizedBox(width: 5),
                Text('135'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
