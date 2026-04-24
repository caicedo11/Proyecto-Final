import 'package:flutter/material.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para capturar el texto
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  String? _rolSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf4f6f9),
      appBar: AppBar(
        title: const Text("Registro de Usuario"),
        backgroundColor: const Color(0xFF2c3e50),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add, size: 80, color: Color(0xFF2c3e50)),
                  const SizedBox(height: 10),
                  const Text("Formulario de Registro", 
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2c3e50))),
                  const SizedBox(height: 20),
                  
                  // Campos de texto
                  _buildTextField(_nombreController, "Nombre", Icons.person),
                  _buildTextField(TextEditingController(), "Apellido Paterno", Icons.person_outline),
                  _buildTextField(_userController, "Usuario", Icons.account_circle),
                  _buildTextField(_emailController, "Correo electrónico", Icons.email, keyboardType: TextInputType.emailAddress),
                  _buildTextField(_passController, "Contraseña", Icons.lock, obscure: true),
                  _buildTextField(TextEditingController(), "Curso", Icons.class_),

                  const SizedBox(height: 10),

                  // Selector de Rol (Dropdown)
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.assignment_ind),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    hint: const Text("Seleccione un rol"),
                    initialValue: _rolSeleccionado,
                    items: const [
                      DropdownMenuItem(value: "2", child: Text("Acudiente")),
                      DropdownMenuItem(value: "3", child: Text("Docente")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _rolSeleccionado = value;
                      });
                    },
                    validator: (value) => value == null ? "Por favor seleccione un rol" : null,
                  ),

                  const SizedBox(height: 20),

                  // Botón Registrarse
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Usuario registrado con éxito")),
                          );
                          Navigator.pop(context); // Regresar al panel admin
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2c3e50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const Text("REGISTRARSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool obscure = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20),
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
        validator: (value) => value!.isEmpty ? "Campo obligatorio" : null,
      ),
    );
  }
}