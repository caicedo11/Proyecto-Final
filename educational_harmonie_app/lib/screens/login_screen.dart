import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _handleLogin() {
    String user = _userController.text.toLowerCase();

    // Lógica de redirección basada en el usuario
    if (user == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (user == 'docente') {
      Navigator.pushReplacementNamed(context, '/docente');
    } else if (user == 'acudiente') {
      Navigator.pushReplacementNamed(context, '/acudiente');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuario no reconocido. Prueba con: admin, docente o acudiente"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f0f0),
      body: Column(
        children: [
          // Header azul superior
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            width: double.infinity,
            color: const Color(0xFF0874e0),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo pequeño en el header reemplazando el icono genérico
                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 40,
                    color: Colors.white, // Esto lo hace ver como un icono blanco
                  ),
                  const SizedBox(width: 15),
                  const Text("EDUCATIONAL HARMONIE", 
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // LOGO PRINCIPAL (Reemplaza el círculo con el icono de la escuela)
                      Container(
                        width: 120,
                        height: 120,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/app_logo.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text("Iniciar Sesión", 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0874e0))),
                      const SizedBox(height: 25),
                      
                      // Campos de texto
                      TextField(
                        controller: _userController,
                        decoration: InputDecoration(
                          hintText: "Usuario",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                      ),
                      const SizedBox(height: 25),
                      
                      // Botón con gradiente
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(colors: [Color(0xFF0874e0), Color(0xFF00a8ff)]),
                        ),
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("INGRESAR", 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(15),
            color: const Color(0xFF0874e0),
            width: double.infinity,
            child: const Text("© 2026 Educational Harmonie", 
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}