import 'package:GvApp/screen/admin/admin_home.dart';
import 'package:GvApp/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:GvApp/screen/login.dart';
import 'package:GvApp/screen/admin/admin_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Verifica el token y el rol
  var token = prefs.getString('token');
  var role = prefs.getString('role');

  String initialRoute;

  if (token != null) {
    initialRoute = role == 'admin' ? '/admin_home' : '/user_home';
  } else {
    initialRoute = '/login';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GladBox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
        ),
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginScreens(),
        '/admin_home': (context) => const AdminHomeScreen(),
        '/user_home': (context) => const HomeScreenG(),
      },
    );
  }
}
