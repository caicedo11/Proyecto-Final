import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/usuario.dart';

class AuthService {
  // Tu IP de Wi-Fi y el puerto de Spring Boot
  final String url = "http://10.0.2.2:8080/...";

  Future<Usuario?> login(String user, String pass) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": user,
          "contrasena": pass, // El servidor usará BCrypt para validar esto
        }),
      );

      if (response.statusCode == 200) {
        // Si el login es exitoso (Status 200)
        return Usuario.fromJson(jsonDecode(response.body));
      } else {
        print("Credenciales incorrectas o error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error de red: $e");
      return null;
    }
  }
}