import 'package:flutter/material.dart';

class AsignacionWidget extends StatelessWidget {
  const AsignacionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Asignar Docentes a Cursos", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2c3e50))),
          const Text("Asigne los docentes a los cursos correspondientes."),
          const SizedBox(height: 20),
          
          // Formulario de asignación
          Card(
            elevation: 2,
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
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Curso"),
                    items: const [
                      DropdownMenuItem(value: "6A", child: Text("6°A")),
                      DropdownMenuItem(value: "7B", child: Text("7°B")),
                      DropdownMenuItem(value: "8A", child: Text("8°A")),
                    ],
                    onChanged: (val) {},
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      onPressed: () {},
                      child: const Text("Asignar", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          const Text("Asignaciones Actuales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          
          // Tabla de Asignaciones
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Docente")),
                DataColumn(label: Text("Curso")),
                DataColumn(label: Text("Acción")),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text("María Gómez")),
                  const DataCell(Text("7°B")),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {},
                  )),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}