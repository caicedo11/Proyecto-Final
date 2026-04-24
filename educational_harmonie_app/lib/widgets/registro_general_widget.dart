import 'package:flutter/material.dart';

class RegistroGeneralWidget extends StatefulWidget {
  const RegistroGeneralWidget({super.key});

  @override
  State<RegistroGeneralWidget> createState() => _RegistroGeneralWidgetState();
}

class _RegistroGeneralWidgetState extends State<RegistroGeneralWidget> {
  final _formKey = GlobalKey<FormState>();
  String? _tipoUsuario;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Registro de Usuarios",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF2c3e50)),
          ),
          const SizedBox(height: 8),
          const Text("Complete el siguiente formulario para registrar nuevos usuarios."),
          const SizedBox(height: 25),
          
          Form(
            key: _formKey,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Tipo de Usuario (Select)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Tipo de usuario",
                        prefixIcon: Icon(Icons.group),
                      ),
                      initialValue: _tipoUsuario,
                      items: const [
                        DropdownMenuItem(value: "docente", child: Text("Docente")),
                        DropdownMenuItem(value: "acudiente", child: Text("Acudiente")),
                        DropdownMenuItem(value: "estudiante", child: Text("Estudiante")),
                      ],
                      onChanged: (val) => setState(() => _tipoUsuario = val),
                      validator: (value) => value == null ? "Seleccione un tipo" : null,
                    ),
                    const SizedBox(height: 15),

                    // Nombre Completo
                    _buildInput("Nombre completo", Icons.person, "Ingrese el nombre completo"),
                    const SizedBox(height: 15),

                    // Correo
                    _buildInput("Correo electrónico", Icons.email, "usuario@ejemplo.com", 
                      keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 15),

                    // Usuario
                    _buildInput("Usuario", Icons.account_box, "Nombre de usuario"),
                    const SizedBox(height: 15),

                    // Password
                    _buildInput("Contraseña", Icons.lock, "********", obscure: true),
                    
                    const SizedBox(height: 30),

                    // Botón Registrar
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2c3e50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Aquí iría la lógica de guardado
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Registrando usuario...")),
                            );
                          }
                        },
                        child: const Text("REGISTRAR", 
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper para construir los inputs rápido
  Widget _buildInput(String label, IconData icon, String hint, {bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      obscureText: obscure,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: (value) => (value == null || value.isEmpty) ? "Este campo es obligatorio" : null,
    );
  }
}