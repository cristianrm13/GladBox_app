import 'dart:convert';
import 'dart:io';
import 'package:GvApp/screen/admin/graficas.dart';
import 'package:GvApp/screen/admin/notifyAdmin.dart';
import 'package:GvApp/screen/extras/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:GvApp/screen/location_status.dart';
import 'package:GvApp/screen/perfil.dart';
import 'package:GvApp/screen/extras/ad_banner.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(date);
    } catch (e) {
      return 'Fecha inválida';
    }
  }

  late Future<List<dynamic>> _futureQuejas;

  @override
  void initState() {
    super.initState();
    _futureQuejas = fetchQuejas();
  }

  Future<List<dynamic>> fetchQuejas() async {
    final url =
        Uri.parse('http://gladboxapi.integrador.xyz:3000/api/v1/quejas/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> quejas = json.decode(response.body);

        quejas.sort((a, b) {
          final dateA = DateTime.parse(a['dateCreated']);
          final dateB = DateTime.parse(b['dateCreated']);
          return dateB.compareTo(dateA);
        });

        return quejas;
      } else {
        throw Exception('Error al obtener quejas: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception(
          'Ups! Estamos tratando de conectar con el servidor, vuelve en unos minutos.');
    } catch (e) {
      throw Exception('Ha ocurrido un error inesperado.');
    }
  }

  Future<void> _refreshQuejas() async {
    setState(() {
      _futureQuejas = fetchQuejas();
    });
    await _futureQuejas;
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
            icon: const Icon(Icons.calendar_today_rounded),
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
                MaterialPageRoute(builder: (context) => const NotifyScreen()),
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
                MaterialPageRoute(
                    builder: (context) => const LocationStatusScreen()),
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
                      hintText: 'Buscar por categoria',
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
            child: RefreshIndicator(
              onRefresh: _refreshQuejas,
              child: FutureBuilder<List<dynamic>>(
                future: _futureQuejas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: _buildErrorCard(snapshot.error.toString()),
                    );
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
          ),
          AdBanner(),
        ],
      ),
    );
  }

  Widget _buildErrorCard(String errorMessage) {
    return Center(
      child: Card(
        color: Colors.red[100],
        margin: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 50),
              const SizedBox(height: 10),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> queja) {
    int likes = queja['likes'] ?? 0;
    bool isLiked = queja['usersLiked'].contains('userId');

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
            if (queja['imageUrl'] != null && queja['imageUrl'].isNotEmpty)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ImageZoomScreen(imageUrl: queja['imageUrl']),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    queja['imageUrl'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Error al cargar la imagen');
                    },
                  ),
                ),
              )
            else
              const Text(
                'Sin imagen',
                style:
                    TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                    color: isLiked ? Colors.blue : Colors.grey,
                  ),
                  onPressed: () async {
                    final complaintId = queja['_id'];
                    final response = await _likeQueja(complaintId);

                    if (response) {
                      setState(() {
                        likes += isLiked ? -1 : 1;
                      });
                    }
                  },
                ),
                Text('$likes'),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.comment_sharp, color: Colors.grey),
                  onPressed: () {
                    final complaintId = queja['_id'];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CommentScreen(complaintId: complaintId),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ImageZoomScreen extends StatelessWidget {
  final String imageUrl;

  const ImageZoomScreen({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen completa'),
        backgroundColor: const Color.fromARGB(255, 103, 201, 107),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 3.0,
        ),
      ),
    );
  }
}

Future<bool> _likeQueja(String complaintId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');

  final Uri url = Uri.parse(
      'http://gladboxapi.integrador.xyz:3000/api/v1/quejas/$complaintId/like');

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    print('Error al hacer el like: $e');
    return false;
  }
}
