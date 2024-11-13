import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://srqagkrqaqztlpxrfduz.supabase.co', // Cambia esta URL por la tuya
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNycWFna3JxYXF6dGxweHJmZHV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEzNDEyNTAsImV4cCI6MjA0NjkxNzI1MH0.-4VpRoRKuWvaKxVEL40ci4DVEdUhGPrMpOmI4j3-_XQ', // Cambia este anonKey por el tuyo
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Eventos',
    );
  }
}
