import 'package:appeven/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'LoginPage.dart'; // Importamos la pantalla de Login

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://srqagkrqaqztlpxrfduz.supabase.co',  // Reemplaza con tu URL de Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNycWFna3JxYXF6dGxweHJmZHV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEzNDEyNTAsImV4cCI6MjA0NjkxNzI1MH0.-4VpRoRKuWvaKxVEL40ci4DVEdUhGPrMpOmI4j3-_XQ',  // Reemplaza con tu anonKey de Supabase
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
