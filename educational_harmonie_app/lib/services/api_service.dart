import 'package:http/http.dart' as http;

class ApiService {
  // Tu IP de Wi-Fi que vimos antes
  final String baseUrl = "http://192.168.1.60:8080/api/v1";

  Future<void> verificarServidor() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/test/connection'));
      if (response.statusCode == 200) {
        print("✅ Conectado al Backend: ${response.body}");
      } else {
        print("❌ Error de servidor: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ No se pudo conectar al servidor. Revisa si Spring Boot está corriendo.");
    }
  }
}