import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login.dart'; // Importamos la pantalla de Login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://your-supabase-url.supabase.co',  // Reemplaza con tu URL de Supabase
    anonKey: 'your-supabase-anon-key',  // Reemplaza con tu anonKey de Supabase
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicación de Eventos',
      home: LoginPage(),  // Página de Login
    );
  }
}
