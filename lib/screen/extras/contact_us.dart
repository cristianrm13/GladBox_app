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
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Esta aplicación fue desarrollada por:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
              ),
              SizedBox(height: 20),
              AnimatedContactCard(
                name: 'Cristian Gerardo Vázquez Ramos',
                imageUrl: 'assets/cristian.jpeg',
                role: 'Desarrollador FullStack',
                email: 'cristiangvramos1313@gmail.com',
                phone: '965 124 8795',
              ),
              SizedBox(height: 20),
              AnimatedContactCard(
                name: 'Luis Osvaldo Pérez Ángel',
                imageUrl: 'assets/luis.jpg',
                role: 'Diseñador UI/UX',
                email: 'luisOPA@gmail.com',
                phone: '965 123 6735',
              ),
              SizedBox(height: 20),
              AnimatedContactCard(
                name: 'Alan David Balbuena Zavala',
                imageUrl: 'assets/alan.jpg',
                role: 'Desarrollador Backend',
                email: 'alanBalbuena@gmail.com',
                phone: '961 567 8901',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedContactCard extends StatefulWidget {
  final String name;
  final String imageUrl;
  final String role;
  final String email;
  final String phone;

  const AnimatedContactCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.role,
    required this.email,
    required this.phone,
  });

  @override
  _AnimatedContactCardState createState() => _AnimatedContactCardState();
}

class _AnimatedContactCardState extends State<AnimatedContactCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _isHovered ? const Color.fromARGB(255, 208, 247, 211) : Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? Colors.green.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
              blurRadius: _isHovered ? 20 : 8,
              spreadRadius: _isHovered ? 1 : 0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
              },
              child: Transform.scale(
                scale: _isHovered ? 1.1 : 1.0,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: AssetImage(widget.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              widget.role,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.email, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  widget.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.phone, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  widget.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
