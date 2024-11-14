import 'package:flutter/material.dart';

class PoliticaPrivacidad extends StatelessWidget {
  const PoliticaPrivacidad({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Política y Privacidad'),
        backgroundColor: Colors.green,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Política de Privacidad',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'Este proyecto tiene como objetivo desarrollar una aplicación móvil que permite a los usuarios de una comunidad reportar quejas, advertencias y sugerencias sobre problemas que afecten su entorno. La aplicación está diseñada para ofrecer un canal digital donde los residentes pueden comunicar incidencias de manera ágil y sencilla, promoviendo una interacción directa con las autoridades locales para la resolución de problemas.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Uso de Datos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'La aplicación recopila información personal y datos relacionados con los reportes realizados por los usuarios, incluyendo imágenes, videos y la ubicación exacta de los problemas reportados. Esta información es utilizada exclusivamente para gestionar y dar seguimiento a los reportes, así como para mejorar los servicios ofrecidos por las autoridades locales.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Recopilación de Datos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Recopilamos datos personales, como nombre, correo electrónico y número de teléfono, cuando los usuarios se registran en la aplicación o envían un reporte. También recopilamos información técnica, como la dirección IP y el tipo de dispositivo utilizado, para mejorar la experiencia del usuario y solucionar problemas técnicos.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Uso de Cookies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Utilizamos cookies para mejorar la funcionalidad de la aplicación y ofrecer una experiencia personalizada. Las cookies son archivos que se almacenan en el dispositivo del usuario y nos ayudan a recordar sus preferencias. Los usuarios pueden desactivar las cookies en la configuración de su dispositivo, pero esto puede afectar la funcionalidad de la aplicación.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Seguridad de la Información',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Tomamos la seguridad de su información muy en serio. Implementamos medidas de seguridad adecuadas para proteger su información personal y evitar accesos no autorizados. Sin embargo, ninguna transmisión de datos a través de Internet puede ser garantizada al 100% como segura.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Manejo de Datos de Menores',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Nuestra aplicación no está destinada a menores de 13 años. No recopilamos intencionadamente información personal de niños menores de esta edad. Si un padre o tutor nos informa que su hijo ha proporcionado información personal, tomaremos medidas para eliminar dicha información de nuestros registros.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Seguimiento y Transparencia',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Los usuarios pueden monitorear el estado de sus reportes en tiempo real, lo que promueve la transparencia y eficiencia en la respuesta de las autoridades. Fomentamos la participación ciudadana y la colaboración en la mejora de la calidad de vida en la comunidad.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Contacto',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Si tiene alguna pregunta o inquietud sobre esta política de privacidad, no dude en contactarnos a través de la aplicación o en nuestro correo electrónico: soporte@ejemplo.com.',
                style: TextStyle(fontSize: 16),
              ),
              // Agrega más contenido de la política de privacidad aquí
            ],
          ),
        ),
      ),
    );
  }
}