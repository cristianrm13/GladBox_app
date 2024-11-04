import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historial de Contacto',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildContactCard('Cristian Gerardo Vázquez Ramos', 'assets/cristian.jpeg'),
              const SizedBox(height: 10),
              _buildContactCard('Luis Osvaldo Pérez Ángel', 'assets/luis.jpg'),
              const SizedBox(height: 10),
              _buildContactCard('Alan David Balbuena Zavala', 'assets/alan.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(String name, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 40, // Aumenta el tamaño del CircleAvatar
          backgroundImage: AssetImage(imageUrl), // Cargar la imagen desde assets
        ),
        title: Text(name),
        trailing: const Icon(Icons.message),
        onTap: () {
          // Aquí puedes agregar la funcionalidad para enviar un mensaje
        },
      ),
    );
  }
}
