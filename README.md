# App Eventos

<img src="https://upen.milaulas.com/pluginfile.php/1/core_admin/logocompact/300x300/1647098022/89925310_2623778167869379_5016977600837320704_n.jpg" alt="Descripción de la imagen" width="600">
<p><strong>Nombre del estudiante: </strong> Diego Llamas Alcantar </p>
<p><strong>Materia:</strong> Mobile Applications 2</p>
<p><strong>Fecha de entrega: </strong>14 de Nobiembre, 2024</p>
<p><strong>Nombre del maestro: </strong> Carlos Alberto Iriarte Mrtinez</p>

  <h1>Introducción</h1>
    <p>
        Este informe muestra el desarrollo de una aplicación de eventos para móviles, que permite a los usuarios ver y registrarse en eventos. 
        Este tipo de práctica es muy útil para aprender y poner en acción habilidades importantes en el desarrollo de aplicaciones, como 
        la programación, el diseño de pantallas, y el manejo de bases de datos en supabase.
    </p>
</body>
</html>
<body>
    <h1>Objetivo de la Aplicación</h1>
    <p><strong>Objetivo General:</strong> Crear una aplicación en la que los usuarios puedan ver y registrarse en eventos, mientras que los administradores puedan agregar, editar y eliminar eventos.</p>
</body>
</html>
# Requisitos del Sistema

## Requisitos Técnicos

- **Flutter**: Herramienta usada para construir la app.
- **Supabase**: Base de datos donde se guarda la información de los eventos y las inscripciones de los usuarios.

## Requisitos Funcionales

- **Sistema de Roles**: La aplicación permite el acceso con distintos roles.
  - **Administrador**: Puede crear, editar y eliminar eventos.
  - **Usuario**: Puede ver y registrarse en eventos.

- **Funciones para los Eventos (CRUD)**: La app permite agregar, ver, editar y eliminar eventos. Cada evento tiene:
  - Nombre
  - Fecha
  - Número de invitados
  - Responsable
  - Tipo de evento
  - Temática
  - Teléfono de contacto
  - Domicilio
  # Descripción de la Aplicación

La aplicación de eventos ayuda a organizar y mostrar eventos de una manera fácil. Los usuarios pueden explorar los eventos disponibles e inscribirse en ellos si lo desean, mientras que los administradores pueden administrar toda la información de los eventos. Los filtros y el sistema de roles mejoran la experiencia de uso.
 ## Codigo fuente
 ```javascript
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
```

```javascript
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
```
```javascript
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'event_list.dart'; // Importamos la página de eventos

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _login() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EventListPage()),
        );
      }
    } catch (error) {
      print('Error de autenticación: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

```
```javascript
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _events;

  @override
  void initState() {
    super.initState();
    _events = _fetchEvents();
  }

  // Función para obtener eventos desde Supabase
  Future<List<Map<String, dynamic>>> _fetchEvents() async {
    final response = await _supabase.from('eventos').select('*').order('fecha', ascending: true).execute();
    if (response.error != null) {
      throw response.error!;
    }
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos Disponibles')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _events,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error al cargar eventos: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay eventos disponibles.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event['nombre']),
                  subtitle: Text('${event['fecha']} - ${event['tipo']}'),
                  onTap: () {
                    // Acción al hacer tap en un evento (e.g., inscribirse)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(event: event),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

extension on PostgrestTransformBuilder<PostgrestList> {
  execute() {}
}

class EventDetailPage extends StatelessWidget {
  final Map<String, dynamic> event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event['nombre'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${event['fecha']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Número de Invitados: ${event['invitados']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Tipo de Evento: ${event['tipo']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Temática: ${event['tematica']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Responsables: ${event['responsables']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Teléfono: ${event['telefono']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Domicilio: ${event['domicilio']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Acción de inscripción (se puede agregar más lógica aquí)
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Inscripción exitosa!')));
              },
              child: Text('Inscribirse'),
            ),
          ],
        ),
      ),
    );
  }
}

```
```javascript
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String _filterType = '';  // Para filtrar por tipo de evento
  bool _isLoading = false;  // Para controlar el estado de carga

  // Función para obtener los eventos desde Supabase
  Future<List<Map<String, dynamic>>> _fetchEvents() async {
    setState(() {
      _isLoading = true;  // Inicia el estado de carga
    });

    final response = await _supabase
        .from('eventos')
        .select()
        .eq('tipo_evento', (_filterType.isEmpty ? null : _filterType) as Object)  // Filtrado por tipo si se aplica
        .order('fecha', ascending: true)
        .execute();

    setState(() {
      _isLoading = false;  // Finaliza el estado de carga
    });

    if (response.error != null) {
      print('Error al obtener eventos: ${response.error!.message}');
      return [];
    }

    return List<Map<String, dynamic>>.from(response.data);
  }

  // Función para inscribirse a un evento
  Future<void> _inscribirseAlEvento(int eventId) async {
    try {
      final response = await _supabase.from('inscripciones').insert({
        'event_id': eventId,
        'user_id': Supabase.instance.client.auth.currentUser!.id,
      }).execute();

      if (response.error != null) {
        throw Exception('Error al inscribirse: ${response.error!.message}');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inscripción exitosa!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al inscribirse: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _filterType.isEmpty ? null : _filterType,
              hint: Text('Filtrar por tipo de evento'),
              items: <String>['', 'Graduación', 'Posada', 'Navidad']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _filterType = newValue ?? '';  // Si el valor es null, se usa el valor vacío
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchEvents(),
              builder: (context, snapshot) {
                if (_isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final events = snapshot.data ?? [];
                if (events.isEmpty) {
                  return Center(child: Text('No hay eventos disponibles.'));
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event['nombre']),
                      subtitle: Text('Fecha: ${event['fecha']}'),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await _inscribirseAlEvento(event['id']);
                        },
                        child: Text('Inscribirse'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

extension on PostgrestTransformBuilder<PostgrestList> {
  execute() {}
}

extension on PostgrestFilterBuilder {
  execute() {}
}
```
  # Capturas de pantalla

  ![event1](https://github.com/user-attachments/assets/2f0308e2-da8f-4331-8937-167cbe5821b4)
![evento2](https://github.com/user-attachments/assets/9c97bc02-c318-41c4-8719-711f2fa9f264)

