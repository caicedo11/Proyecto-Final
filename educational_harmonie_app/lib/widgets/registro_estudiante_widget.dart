import 'package:flutter/material.dart';

class RegistroEstudianteWidget extends StatefulWidget {
  const RegistroEstudianteWidget({super.key});

  @override
  State<RegistroEstudianteWidget> createState() => _RegistroEstudianteWidgetState();
}

class _RegistroEstudianteWidgetState extends State<RegistroEstudianteWidget> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para capturar el texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Control de Alumnos", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
              const SizedBox(height: 20),
              
              // Ciclo Escolar (Read only como en tu HTML)
              TextFormField(
                initialValue: "2025",
                readOnly: true,
                decoration: const InputDecoration(labelText: "Ciclo Escolar", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),

              // Nombre
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: "Nombre del Alumno *", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 15),

              // Apellido
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(labelText: "Apellido del Alumno *", border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 15),

              // Grado (Dropdown)
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: "Grado *", border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(value: "1", child: Text("Primero")),
                  DropdownMenuItem(value: "2", child: Text("Segundo")),
                  DropdownMenuItem(value: "3", child: Text("Tercero")),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aquí llamarás a tu servicio para guardar en Spring Boot
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Inscribiendo alumno...")),
                    );
                  }
                },
                child: const Text("Inscribir Alumno", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}