import 'package:flutter/material.dart';

class RegistrarUsuarioWidget extends StatefulWidget {
  const RegistrarUsuarioWidget({super.key});

  @override
  State<RegistrarUsuarioWidget> createState() => _RegistrarUsuarioWidgetState();
}

class _RegistrarUsuarioWidgetState extends State<RegistrarUsuarioWidget> {
  String? _rolSeleccionado;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Registrar Usuario", 
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2c3e50))),
          const SizedBox(height: 20),
          
          const TextField(decoration: InputDecoration(labelText: "Nombre", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: "Apellido", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(decoration: InputDecoration(labelText: "Correo electrónico", border: OutlineInputBorder())),
          const SizedBox(height: 12),
          const TextField(
            decoration: InputDecoration(labelText: "Contraseña", border: OutlineInputBorder()),
            obscureText: true,
          ),
          const SizedBox(height: 12),
          
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: "Rol", border: OutlineInputBorder()),
            hint: const Text("Seleccione un rol"),
            initialValue: _rolSeleccionado,
            items: const [
              DropdownMenuItem(value: "acudiente", child: Text("Acudiente")),
              DropdownMenuItem(value: "docente", child: Text("Docente")),
              DropdownMenuItem(value: "admin", child: Text("Administrador")),
            ],
            onChanged: (val) => setState(() => _rolSeleccionado = val),
          ),
          
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2c3e50)),
              onPressed: () {},
              child: const Text("Registrar", style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}