import 'package:flutter/material.dart';

class NotificarWidget extends StatelessWidget {
  const NotificarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Notificaciones a Docentes", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2c3e50))),
          const Text("Envía mensajes o recordatorios a los docentes registrados."),
          const SizedBox(height: 20),
          
          // Formulario
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Docente"),
                    items: const [
                      DropdownMenuItem(value: "1", child: Text("María Gómez")),
                      DropdownMenuItem(value: "2", child: Text("Pedro Torres")),
                    ],
                    onChanged: (val) {},
                  ),
                  const TextField(decoration: InputDecoration(labelText: "Asunto")),
                  const TextField(
                    decoration: InputDecoration(labelText: "Mensaje"),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0b63e5)),
                      onPressed: () {},
                      child: const Text("Enviar notificación", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          const Text("Historial de notificaciones", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          
          // Tabla de historial
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Fecha")),
                DataColumn(label: Text("Docente")),
                DataColumn(label: Text("Asunto")),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text("2025-10-25")),
                  DataCell(Text("Pedro Torres")),
                  DataCell(Text("Reunión")),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}