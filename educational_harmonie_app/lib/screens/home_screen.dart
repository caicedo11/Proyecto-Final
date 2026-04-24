import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Asegúrate de haber hecho: flutter pub add carousel_slider

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Colores para el gradiente de fondo
    Color color1 = const Color(0xFFe3f2fd);
    Color color2 = const Color(0xFFbbdefb);

    // Lista de tus imágenes reales (Asegúrate de que coincidan con los nombres en assets)
    final List<String> imgList = [
      'assets/images/home_banner_1.jpg',
      'assets/images/home_banner_2.png',
      'assets/images/home_banner_3.jpg',
      'assets/images/home_banner_4.jpeg',

    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFa3d0f7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "EDUCATIONAL HARMONIE",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SECCIÓN HERO CON GRADIENTE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color1, color2],
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    "BIENVENIDO A EDUCATIONAL HARMONIE",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),
                  
                  // CAROUSEL CON TUS 4 IMÁGENES
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 220.0,
                      autoPlay: true, // Cambian solas
                      enlargeCenterPage: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      viewportFraction: 0.85,
                    ),
                    items: imgList.map((item) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          item,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    )).toList(),
                  ),

                  const SizedBox(height: 30),
                  
                  // LOGO DE LA APP (Reemplazando el icono azul)
                  Image.asset(
                    'assets/images/logonuevo.png',
                    height: 80,
                  ),
                  
                  const SizedBox(height: 30),
                  
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1976d2),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      "Acceder al Sistema",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // SECCIÓN SOBRE NOSOTROS
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text("Sobre Nosotros", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.track_changes, color: Colors.blue, size: 30),
                      title: Text("Misión", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Educación integral basada en valores."),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Card(
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.visibility, color: Colors.blue, size: 30),
                      title: Text("Visión", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Liderazgo educativo para el futuro."),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}