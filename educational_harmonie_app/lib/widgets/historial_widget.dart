import 'package:flutter/material.dart';

class HistorialWidget extends StatelessWidget {
  const HistorialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Historial Disciplinario", 
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2c3e50))),
          const Text("Consulta los reportes registrados en la plataforma."),
          const SizedBox(height: 20),
          
          // Barra de búsqueda
          Row(
            children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar estudiante...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
                child: const Text("Buscar"),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Tabla de resultados
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Estudiante")),
                    DataColumn(label: Text("Grado")),
                    DataColumn(label: Text("Docente")),
                    DataColumn(label: Text("Descripción")),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text("Juan Pérez")),
                      DataCell(Text("7°B")),
                      DataCell(Text("María Gómez")),
                      DataCell(Text("Uso inadecuado uniforme")),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}