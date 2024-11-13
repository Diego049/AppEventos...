class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página de inicio'),
      ),
      body: Center(
        child: Text('Bienvenido a la aplicación de eventos'),
      ),
    );
  }
}
