import 'package:GvApp/screen/home.dart';
import 'package:GvApp/screen/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _acceptedTerms = false;

  // Controladores para cada campo de entrada
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmcontrasenaController = TextEditingController();

  // Función que hace la solicitud HTTP
  Future<void> registerUser(
      String nombre, String correo, String contrasena,String telefono) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://192.168.1.103:3000/api/v1/usuarios'), // Cambia a tu endpoint de registro
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "correo": correo,
          "contrasena": contrasena,
          "telefono": telefono,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso!')),
        );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreens()), 
      );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Image.asset(
              'assets/Gladbox.png',
              height: 50,
            ),
            const SizedBox(height: 40),
            const Text(
              'Crea tu cuenta',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      hintText: 'ex: Jon Smith',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introduce tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _correoController,
                    decoration: const InputDecoration(
                      labelText: 'correo',
                      hintText: 'ex: juan.perez@correo.com',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introduce tu correo';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'telefono',
                      hintText: 'ex: 123 456 7890',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introduce tu telefono';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _contrasenaController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introduce tu contraseña';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmcontrasenaController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar contraseña',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _contrasenaController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _acceptedTerms,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                      ),
                      const Text('Entendí los términos y la política.')
                    ],
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
                        icon: ClipOval(
                          child: Image.asset(
                            'assets/X.jpg',
                            width: 40, // Ancho de la imagen
                            height: 40, // Alto de la imagen
                            fit: BoxFit
                                .cover, // Ajusta la imagen para que cubra el espacio sin distorsionarse
                          ),
                        ),
                        // iconSize: 40,
                        onPressed: () {
                          // Lógica de inicio de sesión con Twitter
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _acceptedTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Creando cuenta...')),
                        );

                        // Llama a la función de registro
                        registerUser(
                          _nombreController.text,
                          _correoController.text,
                          _contrasenaController.text,
                          _telefonoController.text,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    child: const Text('Registrar'),
                  ),
                  const SizedBox(height: 20),
                   
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
