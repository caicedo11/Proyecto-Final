import 'package:flutter/material.dart';

class AcudienteScreen extends StatefulWidget {
  const AcudienteScreen({super.key});

  @override
  State<AcudienteScreen> createState() => _AcudienteScreenState();
}

class _AcudienteScreenState extends State<AcudienteScreen> {
  String _currentView = 'dashboard';

  // Datos de ejemplo (como los que tenías en tu JS)
  final List<Map<String, String>> _reportes = [
    {"fecha": "15/10/2025", "docente": "Profesor Gómez", "motivo": "Inasistencia", "estado": "Resuelto"},
    {"fecha": "21/10/2025", "docente": "Profesora Ruiz", "motivo": "Comportamiento", "estado": "Pendiente"},
  ];

  final List<Map<String, String>> _quejas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PANEL ACUDIENTE"),
        backgroundColor: const Color(0xFF0b63e5),
        foregroundColor: Colors.white,
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0b63e5)),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.family_restroom, color: Colors.white, size: 50),
                  Text("EDUCATIONAL HARMONIE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          _drawerItem(Icons.home, "Inicio", 'dashboard'),
          _drawerItem(Icons.send, "Enviar Queja", 'enviarQueja'),
          _drawerItem(Icons.history, "Historial Reportes", 'verReportes'),
          _drawerItem(Icons.comment, "Historial Quejas", 'verQuejas'),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, String view) {
    return ListTile(
      leading: Icon(icon, color: _currentView == view ? const Color(0xFF0b63e5) : Colors.grey),
      title: Text(title),
      onTap: () {
        setState(() => _currentView = view);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildContent() {
    switch (_currentView) {
      case 'enviarQueja': return _buildFormQueja();
      case 'verReportes': return _buildReportesTable();
      case 'verQuejas': return _buildQuejasTable();
      default: return _buildDashboard();
    }
  }

  // --- 1. Dashboard ---
  Widget _buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Bienvenido al Panel del Acudiente", 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0b63e5))),
        const SizedBox(height: 20),
        Row(
          children: [
            _cardSummary("Reportes", _reportes.length.toString(), Colors.blue),
            const SizedBox(width: 15),
            _cardSummary("Quejas", _quejas.length.toString(), Colors.cyan),
          ],
        ),
      ],
    );
  }

  Widget _cardSummary(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  // --- 2. Formulario de Quejas ---
  Widget _buildFormQueja() {
    return Column(
      children: [
        const Text("Enviar Nueva Queja", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const TextField(decoration: InputDecoration(labelText: "Asunto")),
        const TextField(decoration: InputDecoration(labelText: "Código del Estudiante")),
        const TextField(decoration: InputDecoration(labelText: "Descripción"), maxLines: 4),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {}, 
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0b63e5)),
          child: const Text("Enviar Queja", style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }

  // --- 3. Tablas ---
  Widget _buildReportesTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Historial de Reportes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        DataTable(
          columns: const [DataColumn(label: Text("Fecha")), DataColumn(label: Text("Motivo")), DataColumn(label: Text("Estado"))],
          rows: _reportes.map((r) => DataRow(cells: [
            DataCell(Text(r['fecha']!)),
            DataCell(Text(r['motivo']!)),
            DataCell(Text(r['estado']!, style: TextStyle(color: r['estado'] == 'Resuelto' ? Colors.green : Colors.orange))),
          ])).toList(),
        ),
      ],
    );
  }

  Widget _buildQuejasTable() {
    return const Center(child: Text("No has enviado quejas todavía."));
  }
}