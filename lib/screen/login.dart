import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreens extends StatelessWidget {
  const LoginScreens({super.key});

  // Función para guardar el token en SharedPreferences
  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Función de inicio de sesión
  Future<void> login(BuildContext context, String correo, String contrasena) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.16:3000/api/v1/usuarios/login'), // Cambia a tu URL del servidor
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'correo': correo, 'contrasena': contrasena}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];

        // Guardar token en SharedPreferences
        await saveToken(token);

        // Navegar a la pantalla principal después de iniciar sesión
        Navigator.pushReplacementNamed(context, '/home');
        print('Inicio de sesión exitoso. Token: $token');
      } else {
        // Mostrar error al usuario
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['error'] ?? 'Error de inicio de sesión';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('Error de conexión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al conectar con el servidor')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/Gladbox.png', height: 100),
              const SizedBox(height: 20),
              const Text(
                'Inicia sesión en tu cuenta',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'ex: jon.smith@email.com',
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  login(context, emailController.text, passwordController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text('INICIAR SESIÓN'),
              ),
              const SizedBox(height: 20),
              const Text('o inicia sesión con'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset('assets/google.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Lógica de inicio de sesión con Google
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Image.asset('assets/facebook.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Lógica de inicio de sesión con Facebook
                    },
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Image.asset('assets/X.png'),
                    iconSize: 40,
                    onPressed: () {
                      // Lógica de inicio de sesión con Twitter
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(
                  "¿No tienes una cuenta? INSCRIBIRSE",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
