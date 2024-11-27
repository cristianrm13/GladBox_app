import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({super.key});

  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  List<dynamic> _reports = [];

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://gladboxapi.integrador.xyz:3000/api/v1/quejas/'),
        );

        if (response.statusCode == 200) {
          setState(() {
            _reports = json.decode(response.body);
          });
        } else {
          print('Error al obtener reportes: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Future<void> _updateReportStatus(String reportId, String newStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        final report = _reports.firstWhere((r) => r['_id'] == reportId);
        final title = report['title'] ?? 'Sin título';
        final description = report['description'] ?? 'Sin descripción';
        final category = report['category'] ?? 'Sin categoría';

        final response = await http.patch(
          Uri.parse(
              'http://gladboxapi.integrador.xyz:3000/api/v1/quejas/$reportId'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'status': newStatus,
            'title': title,
            'description': description,
            'category': category,
          }),
        );

        if (response.statusCode == 200) {
          print('Estado actualizado correctamente');
          _fetchReports(); // Refresca la lista después de actualizar
        } else {
          print('Error al actualizar estado: ${response.statusCode}');
          print('Respuesta del servidor: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Token no disponible');
    }
  }

  Future<void> _deleteReport(String reportId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      final response = await http.delete(
        Uri.parse(
            'http://gladboxapi.integrador.xyz:3000/api/v1/quejas/$reportId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _fetchReports();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Queja eliminada exitosamente')),
        );
      } else {
        print('Error al eliminar la queja: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Color _getIconColor(String status) {
    switch (status.toLowerCase()) {
      case 'terminada':
        return Colors.green; // Verde para terminado
      case 'abierta':
        return const Color.fromARGB(
            255, 9, 137, 211); // Naranja para no resuelto
      default:
        return Colors.red; // Rojo para otros estados
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blueGrey),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notificaciones',
          style: TextStyle(color: Colors.green),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _reports.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _reports.length,
                itemBuilder: (context, index) {
                  var report = _reports[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: _getIconColor(report['status']),
                        child: const Icon(
                          Icons.new_releases,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      title: Text(
                        report['status'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            report['description'] ?? '',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            report['dateCreated'] ?? '',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'Eliminar') {
                            bool? confirmDelete = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirmar eliminación'),
                                  content: const Text(
                                      '¿Estás seguro de que deseas eliminar esta queja?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmDelete == true) {
                              _deleteReport(report['_id']);
                            }
                          } else {
                            bool? confirmUpdate = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title:
                                      const Text('Confirmar cambio de estado'),
                                  content: Text(
                                      '¿Estás seguro de que deseas cambiar el estado a "$value"?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(false),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: const Text('Confirmar'),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmUpdate == true) {
                              _updateReportStatus(report['_id'], value);
                            }
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'abierta',
                            child: Text('Marcar como ABIERTA'),
                          ),
                          const PopupMenuItem(
                            value: 'en progreso',
                            child: Text('Marcar como EN PROGRESO'),
                          ),
                          const PopupMenuItem(
                            value: 'terminada',
                            child: Text('Marcar como TERMINADA'),
                          ),
                          const PopupMenuItem(
                            value: 'Eliminar',
                            child: Text('Eliminar Queja'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
