import 'package:flutter/material.dart';

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

  String paisSeleccionado = 'México';
  String generoSeleccionado = 'Género';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
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
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        'País', 
                        paisSeleccionado, 
                        ['México', 'Estados Unidos', 'Canadá'], 
                        (newValue) {
                          setState(() {
                            paisSeleccionado = newValue!;
                          });
                        }
                      ),
                    ),
                    SizedBox(width: 10),
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
                SizedBox(height: 20),
                _buildTextField(
                  'Dirección',
                  controller: direccionController,
                  onTap: () {
                    if (direccionController.text == 'Dirección') {
                      direccionController.clear(); // Borra el texto por defecto
                    }
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                // Aquí puedes acceder a los valores de los controladores
                print("Nombre: ${nombreController.text}");
                print("Usuario: ${usuarioController.text}");
                print("Contraseña: ${contrasenaController.text}");
                print("Email: ${emailController.text}");
                print("Teléfono: ${telefonoController.text}");
                print("Dirección: ${direccionController.text}");
                print("País: $paisSeleccionado");
                print("Género: $generoSeleccionado");

                // Mostrar el SnackBar
                _showUpdateSuccessSnackbar(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
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
    final snackBar = SnackBar(
      content: Text('Actualización exitosa'),
      duration: Duration(seconds: 5), // Duración del SnackBar
    );

    // Mostrar el SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    Future.delayed(Duration(seconds: 5), () {
      Navigator.pop(context); // Regresa a la pantalla anterior (perfil)
      // O si tienes una ruta específica:
      // Navigator.of(context).pushReplacementNamed('/perfil');
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
