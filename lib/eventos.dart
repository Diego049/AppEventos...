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
