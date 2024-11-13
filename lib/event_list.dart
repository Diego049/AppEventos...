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

