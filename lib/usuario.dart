import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final role = _roleController.text;

    try {
      // Crear usuario en Supabase auth
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      final userId = response.user?.id;

      if (userId != null) {
        // Insertar el rol en la tabla de perfiles
        await _supabase.from('profiles').insert({
          'id': userId,
          'role': role, // alumno o administrador
        });

        print('Usuario registrado exitosamente con rol: $role');
        Navigator.pushReplacementNamed(context, '/login');  // Redirige a la página de login
      }
    } catch (error) {
      print('Error al registrar usuario: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Rol (alumno o administrador)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }
}
