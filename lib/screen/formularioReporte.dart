import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';  // Para convertir el body a JSON

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

  Future<void> _submitReport() async {
    final String title = _titleController.text.trim(); // Elimina espacios en blanco
    final String description = _descriptionController.text.trim(); // Elimina espacios en blanco

    // Verificar si todos los campos están llenos
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa el campo "Título".')),
      );
      return;
    }

    if (_categoriaSeleccionada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una categoría.')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa el campo "Descripción".')),
      );
      return;
    }

    // Si falta la imagen, podrías mostrar un mensaje o seguir con el envío del reporte sin imagen
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecciona una imagen.')),
      );
      return;
    }

    try {
      // Aquí se envía el reporte con los datos en formato JSON
      final response = await http.post(
        Uri.parse('http://192.168.0.16:3000/api/v1/quejas'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'category': _categoriaSeleccionada,
        }),
      );

      print('Status code: ${response.statusCode}'); // Imprimir el estado de la respuesta

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reporte enviado exitosamente')),
        );
        Navigator.pop(context);
      } else {
        print('Error al enviar el reporte: ${response.body}'); // Imprimir el cuerpo de la respuesta
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al enviar el reporte: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception: $e'); // Imprimir cualquier excepción que ocurra
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
}
