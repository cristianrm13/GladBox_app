import 'package:flutter/material.dart';
import 'package:GvApp/screen/sign_up.dart';

class LoginScreens extends StatelessWidget {
  const LoginScreens({super.key});

  @override
  Widget build(BuildContext context) {
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
                  // Aquí va la lógica de inicio de sesión
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
                    icon: Image.asset('assets/X.png'), // Asegúrate de tener el icono de Twitter
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
                  // Aquí se realiza la navegación a la pantalla de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()), // SignUpScreen es la pantalla de registro
                  );
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