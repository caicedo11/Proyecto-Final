import 'package:flutter/material.dart';
// Importación de tus pantallas
// Asegúrate de que los nombres de los archivos coincidan con los que tienes en lib/screens/
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin_screen.dart';
import 'screens/docente_screen.dart';

void main() {
  runApp(const EducationalHarmonieApp());
}

class EducationalHarmonieApp extends StatelessWidget {
  const EducationalHarmonieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Educational Harmonie',
      
      // CONFIGURACIÓN DE TEMA GLOBAL (Como tu CSS)
      theme: ThemeData(
        primaryColor: const Color(0xFF0874e0),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0874e0),
          primary: const Color(0xFF0874e0),
        ),
        // Estilo para todos los Inputs de la app
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        // Estilo para todos los Botones de la app
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0874e0),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        useMaterial3: true,
      ),

      // DEFINICIÓN DE RUTAS (Navegación)
      initialRoute: '/', // La app inicia en el Home (Bienvenida)
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/admin': (context) => const AdminScreen(),
        '/docente': (context) => const DocenteScreen(),
        // Agrega aquí las rutas para Acudiente y Registro cuando tengas los archivos listos
      },
    );
  }
}