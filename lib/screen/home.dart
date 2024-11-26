import 'dart:convert';
import 'dart:io';
import 'package:GvApp/screen/extras/comments_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:GvApp/screen/location_status.dart';
import 'package:GvApp/screen/notificaciones.dart';
import 'package:GvApp/screen/perfil.dart';
import 'package:GvApp/screen/formularioReporte.dart';
import 'package:GvApp/screen/extras/ad_banner.dart';
import 'package:photo_view/photo_view.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenG extends StatefulWidget {
  const HomeScreenG({super.key});

  @override
  _HomeScreenGState createState() => _HomeScreenGState();
}

class _HomeScreenGState extends State<HomeScreenG> {
  String formatDate(String dateString) {
    try {
      // Convertir la fecha a un objeto DateTime
      final date = DateTime.parse(dateString);
      // Formatear la fecha en un formato legible
      return DateFormat('d \'de\' MMMM \'de\' yyyy', 'es').format(date);
    } catch (e) {
      return 'Fecha inválida'; // En caso de error
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
        // Decodifica el JSON
        List<dynamic> quejas = json.decode(response.body);

        // Ordena las quejas por la fecha de creación (descendente)
        quejas.sort((a, b) {
          final dateA = DateTime.parse(a['dateCreated']);
          final dateB = DateTime.parse(b['dateCreated']);
          return dateB.compareTo(dateA); // Más reciente primero
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
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const FormularioReporte()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()),
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
                onPressed: () {
                  // Recargar la página
                },
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
    int likes = queja['likes'] ?? 0;  // Obtener el número de likes de la queja
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
                // Botón de like
              IconButton(
                icon: Icon(
                  isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                  color: isLiked ? Colors.blue : Colors.grey,
                ),
                onPressed: () async {
                  // Aquí puedes implementar la lógica para dar like a la queja
                  final complaintId = queja['_id'];
                  final response = await _likeQueja(complaintId);  // Función para enviar el like al backend

                  if (response) {
                    setState(() {
                      // Actualizar el contador de likes y el estado de like
                      likes += isLiked ? -1 : 1;
                    });
                  }
                },
              ),
              Text('$likes'), // Contador de likes

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
          minScale: PhotoViewComputedScale
              .contained, // Escala mínima (dentro del contenedor)
          maxScale: PhotoViewComputedScale.covered * 3.0,
        ),
      ),
    );
  }
}



Future<bool> _likeQueja(String complaintId) async {
  // Aquí debes obtener el userId dinámicamente (por ejemplo, desde el contexto de autenticación)
  SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(
        'userId');   // Reemplaza esto con el código que obtiene el userId del usuario autenticado
  
  final Uri url = Uri.parse('http://gladboxapi.integrador.xyz:3000/api/v1/quejas/$complaintId/like');

  try {
    // Enviamos la solicitud POST
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({'userId': userId}),
    );

    // Verificamos si la respuesta es exitosa (status 200)
    if (response.statusCode == 200) {
      // Aquí puedes manejar la lógica en caso de éxito (p. ej., actualizando el contador de likes)
      return true;
    } else {
      // Aquí puedes manejar diferentes códigos de error si es necesario
      print('Error: ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Si ocurre algún error en la solicitud HTTP
    print('Error al hacer el like: $e');
    return false;
  }
}
