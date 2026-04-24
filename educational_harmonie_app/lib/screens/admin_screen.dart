import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _currentView = 'dashboard';
  
  // Variables para datos reales de la BD
  int estudiantesCount = 0;
  int usuariosCount = 0;
  int reportesCount = 0;
  int invitacionesCount = 0;
  bool isLoading = true;

  // IP para el emulador (apunta a tu localhost:8080)
  final String baseUrl = "http://10.0.2.2:8080/api/dashboard/stats";

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          estudiantesCount = data['estudiantes'] ?? 0;
          usuariosCount = data['usuarios'] ?? 0;
          reportesCount = data['reportes'] ?? 0;
          invitacionesCount = data['invitaciones'] ?? 0;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error de conexión: $e");
      setState(() => isLoading = false);
    }
  }

  void _setView(String viewName) {
    setState(() => _currentView = viewName);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PANEL ADMINISTRADOR", 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF0b63e5),
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0b63e5), Color(0xFF00b4ff)],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // LOGO CORREGIDO SEGÚN TUS ASSETS
                    Image.asset(
                      'assets/images/app_logo.jpg', 
                      height: 70,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.school, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    const Text("EDUCATIONAL HARMONIE", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              _drawerItem(Icons.home, "Inicio", () => _setView('dashboard')),
              _drawerItem(Icons.people, "Usuarios", () => _setView('usuarios')),
              _drawerItem(Icons.mail_outline, "Invitar Usuarios", () => _setView('invitaciones')),
              _drawerItem(Icons.school, "Estudiantes", () => _setView('estudiantes')),
              _drawerItem(Icons.history, "Historial", () => _setView('historial')),
              const Divider(color: Colors.white54),
              _drawerItem(Icons.logout, "Cerrar Sesión", () => Navigator.pushReplacementNamed(context, '/')),
            ],
          ),
        ),
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : _buildContent(),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  Widget _buildContent() {
    switch (_currentView) {
      case 'invitaciones': return _buildInvitacionView();
      case 'usuarios': return const Center(child: Text("Tabla de Usuarios Registrados"));
      case 'estudiantes': return const Center(child: Text("Lista de Estudiantes"));
      default: return _buildDashboard();
    }
  }

  // VISTA DE INVITACIONES CON BARRA DE CORREO
  Widget _buildInvitacionView() {
    final TextEditingController emailController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Invitar Nuevo Usuario", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0b63e5))),
          const SizedBox(height: 10),
          const Text("Ingrese el correo electrónico para enviar el formulario de registro."),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: "ejemplo@correo.com",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0b63e5),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invitación enviada a ${emailController.text}"))
                  );
                },
                child: const Text("ENVIAR", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text("Registros Pendientes de Aprobación", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Expanded(
            child: Center(child: Text("No hay registros pendientes por ahora.")),
          )
        ],
      ),
    );
  }

  Widget _buildDashboard() {
    return RefreshIndicator(
      onRefresh: _fetchDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _dashboardCard("Estudiantes", estudiantesCount.toString(), Icons.emoji_emotions),
            _dashboardCard("Usuarios", usuariosCount.toString(), Icons.people_alt),
            _dashboardCard("Reportes", reportesCount.toString(), Icons.gavel),
            _dashboardCard("Invitaciones", invitacionesCount.toString(), Icons.mail),
          ],
        ),
      ),
    );
  }

  Widget _dashboardCard(String title, String count, IconData icon) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0b63e5), Color(0xFF00b4ff)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              Text(count, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, color: Colors.white24, size: 50),
        ],
      ),
    );
  }
}