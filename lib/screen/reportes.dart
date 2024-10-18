import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  _FormularioReporteState createState() => _FormularioReporteState();
}

class _FormularioReporteState extends State<Products> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  
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
    final String titulo = _tituloController.text;
    final String descripcion = _descripcionController.text;

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una imagen')),
      );
      return;
    }

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.103:3000/api/productos'), // Cambia la URL si es necesario
    );

    request.fields['titulo'] = titulo;
    request.fields['categoria'] = _categoriaSeleccionada;
    request.fields['descripcion'] = descripcion;

    // Añade la imagen al request
    request.files.add(
      await http.MultipartFile.fromPath(
        'imagen', 
        _selectedImage!.path,
      ),
    );

    // Envía el request
    final response = await request.send();
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reporte enviado exitosamente')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar el reporte')),
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
                controller: _tituloController,
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
                controller: _descripcionController,
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
