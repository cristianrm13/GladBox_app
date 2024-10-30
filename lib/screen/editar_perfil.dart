import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class EditarPerfil extends StatefulWidget {
  const EditarPerfil({super.key});

  @override
  EditarPerfilState createState() => EditarPerfilState();
}

class EditarPerfilState extends State<EditarPerfil> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController(text: 'Dirección');

  String paisSeleccionado = 'San Jacinto';
  String generoSeleccionado = 'Género';
  final String userId = "671ae6cdaf93fdd4ffd34894"; // ID del usuario
  final LocalAuthentication auth = LocalAuthentication();

  Future<void> actualizarUsuario() async {
    final url = Uri.parse('http://192.168.1.105:3000/api/v1/usuarios/$userId');
    
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'nombre': nombreController.text,
        'correo': emailController.text,
        'contrasena': contrasenaController.text,
        'telefono': telefonoController.text,
      }),
    );

    if (response.statusCode == 200) {
      _showUpdateSuccessSnackbar(context);
    } else {
      print("Error al actualizar usuario: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar el perfil')),
      );
    }
  }

  Future<void> _authenticateAndSubmit() async {
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Por favor verifica tu identidad con tu huella dactilar',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        await actualizarUsuario();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Autenticación fallida. No se realizó la actualización.')),
        );
      }
    } on PlatformException catch (e) {
      print("Error en autenticación: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al intentar autenticarse')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Editar perfil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                _buildTextField('Nombre completo', controller: nombreController),
                _buildTextField('Nombre de usuario', controller: usuarioController),
                _buildTextField('Contraseña', obscureText: true, controller: contrasenaController),
                _buildTextField('Email', controller: emailController),
                _buildTextField('Teléfono', controller: telefonoController),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        'Colonia', 
                        paisSeleccionado, 
                        ['El Capricho', 'San Jacinto', '5 de Mayo', 'Mercado', 'Las pilas', 'El Maluco','Centro', '18 de Marzo', 'Los Manguitos','El Suspiro'], 
                        (newValue) {
                          setState(() {
                            paisSeleccionado = newValue!;
                          });
                        }
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdownField(
                        'Género', 
                        generoSeleccionado, 
                        ['Género', 'Hombre', 'Mujer', 'Otro'],
                        (newValue) {
                          setState(() {
                            generoSeleccionado = newValue!;
                          });
                        }
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  'Dirección',
                  controller: direccionController,
                  onTap: () {
                    if (direccionController.text == 'Dirección') {
                      direccionController.clear();
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _authenticateAndSubmit, // Cambiado para autenticar y luego actualizar
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'CONFIRMAR',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateSuccessSnackbar(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('Actualización exitosa'),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pop(context);
    });
  }

  Widget _buildTextField(String label, {bool obscureText = false, required TextEditingController controller, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
