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

    if (user == 'admin') {
      Navigator.pushReplacementNamed(context, '/admin');
    } else if (user == 'docente') {
      Navigator.pushReplacementNamed(context, '/docente');
    } else if (user == 'acudiente') {
      Navigator.pushReplacementNamed(context, '/acudiente');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Usuario no reconocido"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),

      body: Column(
        children: [

          /// 🔵 HEADER (igual HTML)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF0874E0),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 5)
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.menu_book, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "EDUCATIONAL HARMONIE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    "HOME",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),

          /// 🔵 CONTENIDO
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),

                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 24,
                      )
                    ],
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      /// 🔵 LOGO
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0874E0), width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0874E0).withOpacity(0.3),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/app_logo.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Educational Harmonie",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF0874E0),
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      const Text(
                        "INICIAR SESIÓN",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0874E0),
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔵 INPUT USUARIO
                      TextField(
                        controller: _userController,
                        decoration: InputDecoration(
                          hintText: "Usuario",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔵 INPUT PASSWORD
                      TextField(
                        controller: _passController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// 🔵 BOTÓN (GRADIENTE IGUAL HTML)
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0874E0), Color(0xFF00A8FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x660874E0),
                              blurRadius: 10,
                            )
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Ingresar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// 🔵 FOOTER (igual HTML)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(
              color: Color(0xFF0874E0),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 8)
              ],
            ),
            child: Column(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/app_logo.jpg',
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "© 2026 Educational Harmonie",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}