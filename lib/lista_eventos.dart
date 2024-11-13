class EventListPage extends StatefulWidget {
  final String role; // 'admin' o 'user'
  EventListPage({required this.role});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _events = [];
  String? _selectedType;

  Future<void> _fetchEvents() async {
    var query = _supabase
        .from('eventos')
        .select()
        .order('fecha', ascending: true);

    if (_selectedType != null && _selectedType!.isNotEmpty) {
      query = query.eq('tipo', _selectedType);
    }

    final response = await query.execute();

    if (response.error == null) {
      setState(() {
        _events = List<Map<String, dynamic>>.from(response.data);
      });
    } else {
      print('Error al obtener eventos: ${response.error?.message}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eventos'),
        actions: widget.role == 'admin'
            ? [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EventFormPage()),
                  ).then((_) => _fetchEvents()),
                ),
              ]
            : [],
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: Text('Filtrar por tipo'),
            value: _selectedType,
            items: <String>['Conferencia', 'Taller', 'Seminario'] // Ejemplo de tipos
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedType = newValue;
                _fetchEvents();
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                final event = _events[index];
                return ListTile(
                  title: Text(event['nombre']),
                  subtitle: Text('Fecha: ${event['fecha']}'),
                  onTap: () {
                    if (widget.role == 'admin') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventFormPage(event: event),
                        ),
                      ).then((_) => _fetchEvents());
                    }
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
