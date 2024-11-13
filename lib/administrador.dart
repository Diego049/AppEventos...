import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventFormPage extends StatefulWidget {
  final Map<String, dynamic>? event;
  EventFormPage({this.event});

  @override
  _EventFormPageState createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  final _nombreController = TextEditingController();
  final _fechaController = TextEditingController();
  final _invitadosController = TextEditingController();
  final _responsablesController = TextEditingController();
  final _tipoController = TextEditingController();
  final _tematicaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _domicilioController = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> _saveEvent() async {
    final data = {
      'nombre': _nombreController.text,
      'fecha': _fechaController.text,
      'invitados': int.tryParse(_invitadosController.text) ?? 0,
      'responsables': _responsablesController.text,
      'tipo': _tipoController.text,
      'tematica': _tematicaController.text,
      'telefono': _telefonoController.text,
      'domicilio': _domicilioController.text,
    };

    if (widget.event == null) {
      await _supabase.from('eventos').insert(data).execute();
    } else {
      await _supabase
          .from('eventos')
          .update(data)
          .eq('id', widget.event!['id'])
          .execute();
    }

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _nombreController.text = widget.event!['nombre'];
      _fechaController.text = widget.event!['fecha'];
      _invitadosController.text = widget.event!['invitados'].toString();
      _responsablesController.text = widget.event!['responsables'];
      _tipoController.text = widget.event!['tipo'];
      _tematicaController.text = widget.event!['tematica'];
      _telefonoController.text = widget.event!['telefono'];
      _domicilioController.text = widget.event!['domicilio'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.event == null ? 'Crear Evento' : 'Editar Evento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _fechaController,
                decoration: InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
              ),
              TextField(
                controller: _invitadosController,
                decoration: InputDecoration(labelText: 'Número de Invitados'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _responsablesController,
                decoration: InputDecoration(labelText: 'Responsables'),
              ),
              TextField(
                controller: _tipoController,
                decoration: InputDecoration(labelText: 'Tipo de Evento'),
              ),
              TextField(
                controller: _tematicaController,
                decoration: InputDecoration(labelText: 'Temática'),
              ),
              TextField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono de Contacto'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _domicilioController,
                decoration: InputDecoration(labelText: 'Domicilio del Evento'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text(widget.event == null ? 'Crear Evento' : 'Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
