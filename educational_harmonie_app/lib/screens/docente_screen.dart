import 'package:flutter/material.dart';

class DocenteScreen extends StatefulWidget {
  const DocenteScreen({super.key});

  @override
  State<DocenteScreen> createState() => _DocenteScreenState();
}

class _DocenteScreenState extends State<DocenteScreen> {
  // Controlamos qué vista mostrar
  String _currentView = 'dashboard';

  // Simulamos listas de datos para las tablas
  final List<Map<String, String>> _reportes = [
    {'estudiante': 'Juan Pérez', 'tipo': 'Leve', 'fecha': '2026-04-20'},
  ];
  final List<Map<String, String>> _quejas = [
    {'acudiente': 'Rosa Melba', 'asunto': 'Uniforme', 'estado': 'Pendiente'},
  ];
  final List<Map<String, String>> _notificaciones = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PANEL DOCENTE"),
        backgroundColor: const Color(0xFF0b63e5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () {
              // Espacio para menú de perfil
            },
          ),
        ],
      ),
      drawer: _buildSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _buildMainContent(),
      ),
    );
  }

  // --- Sidebar (Navegación Lateral) ---
  Widget _buildSidebar() {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0b63e5), Color(0xFF00b4ff)]),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // CORREGIDO: Antes decía Murphy
                children: [
                  Icon(Icons.book_outlined, color: Colors.white, size: 50),
                  SizedBox(height: 10),
                  Text("EDUCATIONAL HARMONIE", 
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          _sidebarItem(Icons.home, "Inicio", 'dashboard'),
          _sidebarItem(Icons.edit, "Registrar Reporte", 'registrar'),
          _sidebarItem(Icons.folder_open, "Historial", 'historial'),
          _sidebarItem(Icons.comment, "Quejas", 'quejas'),
          _sidebarItem(Icons.notifications, "Notificar", 'notificar'),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sidebarItem(IconData icon, String title, String view) {
    bool isSelected = _currentView == view;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF0b63e5) : Colors.grey),
      title: Text(title, style: TextStyle(
        color: isSelected ? const Color(0xFF0b63e5) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      )),
      selected: isSelected,
      onTap: () {
        setState(() => _currentView = view);
        Navigator.pop(context);
      },
    );
  }

  // --- Selector de Contenido Principal ---
  Widget _buildMainContent() {
    switch (_currentView) {
      case 'registrar': return _buildFormReporte();
      case 'historial': return _buildHistorialTable();
      case 'quejas': return _buildQuejasTable();
      case 'notificar': return _buildFormNotificar();
      default: return _buildDashboard();
    }
  }

  // --- 1. Dashboard ---
  Widget _buildDashboard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Panel de Control Docente", 
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0b63e5))),
        const SizedBox(height: 20),
        Wrap(
          spacing: 15, runSpacing: 15,
          children: [
            _dashboardCard("Reportes", _reportes.length.toString(), Icons.analytics, Colors.blue),
            _dashboardCard("Quejas", _quejas.length.toString(), Icons.warning, Colors.orange),
            _dashboardCard("Notificaciones", "0", Icons.send, Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _dashboardCard(String label, String count, IconData icon, Color color) {
    return Container(
      width: 150, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 30),
          const SizedBox(height: 10),
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  // --- 2. Formulario de Registro ---
  Widget _buildFormReporte() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Registrar Reporte Disciplinario", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            const TextField(decoration: InputDecoration(labelText: "Nombre del Estudiante", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: "Motivo/Falta", border: OutlineInputBorder())),
            const SizedBox(height: 10),
            const TextField(decoration: InputDecoration(labelText: "Descripción Detallada", border: OutlineInputBorder()), maxLines: 3),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0b63e5)),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Reporte guardado con éxito")));
                }, 
                child: const Text("REGISTRAR Y NOTIFICAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  // --- 3. Tablas ---
  Widget _buildHistorialTable() {
    return _buildTableContainer("Historial de Reportes", ["Estudiante", "Tipo", "Fecha"], _reportes);
  }

  Widget _buildQuejasTable() {
    return _buildTableContainer("Quejas de Acudientes", ["Acudiente", "Asunto", "Estado"], _quejas);
  }

  Widget _buildTableContainer(String title, List<String> columns, List<Map<String, String>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0b63e5))),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.grey.shade100),
              columns: columns.map((c) => DataColumn(label: Text(c, style: const TextStyle(fontWeight: FontWeight.bold)))).toList(),
              rows: data.map((item) => DataRow(cells: [
                DataCell(Text(item.values.elementAt(0))),
                DataCell(Text(item.values.elementAt(1))),
                DataCell(Text(item.values.elementAt(2))),
              ])).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // --- 4. Notificar ---
  Widget _buildFormNotificar() {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.notifications_active, size: 80, color: Colors.grey),
          Text("Sección de Notificaciones Generales", style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }
}