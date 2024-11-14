import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  String _filterType = '';  // Para filtrar por tipo de evento

  // Función para obtener los eventos desde Supabase
  Future<List<Map<String, dynamic>>> _fetchEvents() async {
    final response = await _supabase
        .from('eventos')
        .select()
        .eq('tipo', _filterType)  // Filtrado por tipo si se aplica
        .order('fecha', ascending: true)
        .execute();

    if (response.error != null) {
      print('Error al obtener eventos: ${response.error!.message}');
      return [];
    }

    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Eventos')),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _filterType,
            hint: Text('Filtrar por tipo de evento'),
            items: <String>['', 'Conferencia', 'Taller', 'Seminario']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _filterType = newValue!;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final events = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event['nombre']),
                      subtitle: Text('Fecha: ${event['fecha']}'),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          // Inscripción al evento
                          await _supabase.from('inscripciones').insert({
                            'event_id': event['id'],
                            'user_id': Supabase.instance.client.auth.currentUser!.id,
                          }).execute();
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
