import 'package:flutter/material.dart';
import 'package:GvApp/screen/formularioReporte.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/Gladbox.png'), // Cambia 'logo.png' por tu logo
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Acción para agregar una publicación o cualquier otra acción
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormularioReporte()),
                 );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Acción para notificaciones
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Acción para ajustes
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de entrada para crear una nueva publicación
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/USER.jpg'), // Cambia la imagen del perfil
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
          // Lista de publicaciones
          Expanded(
            child: ListView.builder(
              itemCount: 2, // Cambia este valor por el número de publicaciones que tengas
              itemBuilder: (context, index) {
                return _buildPostCard();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Trans.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Feeds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Reportar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información del usuario y tiempo
            const Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/USER.jpg'), // Imagen del usuario
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Juan Perez',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '08:39 am',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Texto de la publicación
            const Text(
              'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit. Fringilla Natoque Id Aenean.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Imagen de la publicación
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/Gladbox.png', // Cambia la imagen de la publicación
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            // Interacciones de la publicación (likes y comentarios)
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
