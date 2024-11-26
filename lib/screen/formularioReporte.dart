/* import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; 

class FormularioReporte extends StatefulWidget {
  const FormularioReporte({super.key});

  @override
  _FormularioReporteState createState() => _FormularioReporteState();
}

class _FormularioReporteState extends State<FormularioReporte> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  String _categoriaSeleccionada = 'Alumbrado'; // Categoría por defecto
  File? _selectedImage; // Para almacenar la imagen seleccionada
  final ImagePicker _picker = ImagePicker(); // Instancia de ImagePicker

  Future<void> _pickImage() async {
    // Verificar el estado del permiso de almacenamiento
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // Solicitar permiso si no está concedido
      await Permission.storage.request();
    }

    // Seleccionar la imagen
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Guardamos la imagen seleccionada
      });
    } else {
      print('No se seleccionó ninguna imagen.');
    }
  }


/* Future<void> _submitReport() async {
  final String title = _titleController.text.trim();
  final String description = _descriptionController.text.trim();

  // Validaciones
  if (title.isEmpty || _categoriaSeleccionada.isEmpty || description.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, completa todos los campos y selecciona una imagen.')),
    );
    return;
  }

  // Obtén el token de SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  if (token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error de autenticación. Por favor, inicia sesión de nuevo.')),
    );
    Navigator.pushReplacementNamed(context, '/login');
    return;
  }

  try {
    // Envía el reporte con el token en los headers
    final response = await http.post(
      Uri.parse('http://gladboxapi.integrador.xyz:3000/api/v1/quejas'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Incluye el token aquí
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'category': _categoriaSeleccionada,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado exitosamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar el reporte: ${response.body}')),
      );
    }
  } catch (e) {
    print('Exception: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al enviar el reporte.')),
    );
  }
}
 */

Future<void> _submitReport() async {
  final String title = _titleController.text.trim();
  final String description = _descriptionController.text.trim();

  if (title.isEmpty || _categoriaSeleccionada.isEmpty || description.isEmpty || _selectedImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, completa todos los campos y selecciona una imagen.')),
    );
    return;
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';

  if (token.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error de autenticación. Por favor, inicia sesión de nuevo.')),
    );
    Navigator.pushReplacementNamed(context, '/login');
    return;
  }

  try {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://gladboxapi.integrador.xyz:3000/api/v1/quejas'),
    );

    request.headers.addAll({
      "Authorization": "Bearer $token",
    });

    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['category'] = _categoriaSeleccionada;

    // Adjunta la imagen al cuerpo de la solicitud
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // Nombre del campo esperado en el backend
        _selectedImage!.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado exitosamente')),
      );
      Navigator.pop(context);
    } else {
      final responseBody = await response.stream.bytesToString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al enviar el reporte: $responseBody')),
      );
    }
  } catch (e) {
    print('Exception: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Error al enviar el reporte.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Crear reporte',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/Gladbox.png', width: 40),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Título',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categoría',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                items: <String>['Alumbrado', 'Baches', 'Limpieza', 'Seguridad']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _categoriaSeleccionada = newValue!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Descripción...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Subir evidencias',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage, // Método para seleccionar la imagen
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text('Tap para seleccionar una imagen'),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReport, // Llama a la función que envía el reporte
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reportar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FormularioReporte extends StatefulWidget {
  const FormularioReporte({super.key});

  @override
  _FormularioReporteState createState() => _FormularioReporteState();
}

class _FormularioReporteState extends State<FormularioReporte> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _categoriaSeleccionada = 'alumbrado'; // Categoría por defecto
  File? _selectedImage; // Para almacenar la imagen seleccionada
  final ImagePicker _picker = ImagePicker(); // Instancia de ImagePicker

  Future<void> _pickImage() async {
    // Verificar el estado del permiso de almacenamiento
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // Solicitar permiso si no está concedido
      await Permission.storage.request();
    }

    // Seleccionar la imagen
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path); // Guardamos la imagen seleccionada
      });
    } else {
      print('No se seleccionó ninguna imagen.');
    }
  }

  Future<void> _submitReport() async {
    final String title = _titleController.text.trim();
    final String description = _descriptionController.text.trim();

    if (title.isEmpty || _categoriaSeleccionada.isEmpty || description.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos y selecciona una imagen.')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error de autenticación. Por favor, inicia sesión de nuevo.')),
      );
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://gladboxapi.integrador.xyz:3000/api/v1/quejas'),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
      });

      request.fields['title'] = title;
      request.fields['description'] = description;
      request.fields['category'] = _categoriaSeleccionada;

      // Adjunta la imagen al cuerpo de la solicitud
      request.files.add(
        await http.MultipartFile.fromPath(
          'image', // Nombre del campo esperado en el backend
          _selectedImage!.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mostrar el diálogo de confirmación
        _showConfirmationDialog();
      } else {
        final responseBody = await response.stream.bytesToString();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar el reporte: $responseBody')),
        );
      }
    } catch (e) {
      print('Exception: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el reporte.')),
      );
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reporte enviado"),
          content: const Text(
            "Tu queja está siendo enviada a las autoridades correspondientes. No olvides revisar tus notificaciones.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.pop(context); // Vuelve a la pantalla anterior
              },
              child: const Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresar a la pantalla anterior
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Crear reporte',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/Gladbox.png', width: 40),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Título',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: '...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Categoría',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _categoriaSeleccionada,
                items: <String>['alumbrado', 'baches', 'limpieza', 'seguridad']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _categoriaSeleccionada = newValue!;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Descripción',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Descripción...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Subir evidencias',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage, // Método para seleccionar la imagen
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text('Tap para seleccionar una imagen'),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: _submitReport, // Llama a la función que envía el reporte
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reportar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
