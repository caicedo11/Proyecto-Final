import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<String> imgList = [
    'assets/images/home_banner_1.jpg',
    'assets/images/home_banner_2.png',
    'assets/images/home_banner_3.jpg',
    'assets/images/home_banner_4.jpeg',
  ];

  bool chatVisible = false;
  final TextEditingController chatController = TextEditingController();

  final List<Map<String, String>> mensajes = [
    {"tipo": "bot", "texto": "👋 ¡Hola! Soy tu asistente de Educational Harmonie"}
  ];

  void enviarMensaje() {
    if (chatController.text.trim().isEmpty) return;

    setState(() {
      mensajes.add({"tipo": "user", "texto": chatController.text});
      mensajes.add({
        "tipo": "bot",
        "texto": "Respuesta automática (conecta tu API luego)"
      });
      chatController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      body: Stack(
        children: [

          /// 🔵 CONTENIDO PRINCIPAL
          SingleChildScrollView(
            child: Column(
              children: [

                /// 🔵 HEADER RESPONSIVE (ARREGLADO)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  color: const Color(0xFFA3D0F7),
                  child: SafeArea(
                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Image.asset(
                                'assets/images/app_logo.jpg',
                                width: 45,
                                height: 45,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Flexible(
                              child: Text(
                                "EDUCATIONAL HARMONIE",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 15,
                          children: const [
                            Text("Inicio"),
                            Text("Nosotros"),
                            Text("Contacto"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// 🔵 HERO
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
                    ),
                  ),
                  child: Column(
                    children: [

                      const Text(
                        "BIENVENIDO A EDUCATIONAL HARMONIE",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 25),

                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          enlargeCenterPage: true,
                        ),
                        items: imgList.map((item) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
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

                      const SizedBox(height: 25),

                      const Text(
                        "Formando estudiantes con valores, conocimiento y liderazgo",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 25),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1976D2),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        child: const Text("Acceder al Sistema"),
                      )
                    ],
                  ),
                ),

                /// 🔵 NOSOTROS
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      const Text(
                        "Sobre Nosotros",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 20),

                      Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        children: [
                          _card("Misión", "Educación integral basada en valores."),
                          _card("Visión", "Liderazgo educativo para el futuro."),
                          _card("Valores", "Respeto, honestidad y excelencia."),
                        ],
                      )
                    ],
                  ),
                ),

                /// 🔵 CONTACTO
                Container(
                  padding: const EdgeInsets.all(30),
                  color: Colors.white,
                  child: Column(
                    children: const [
                      Text("Contacto",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15),
                      Text("TECNOLÓGICO COMFENALCO"),
                      Text("+57 3102455894"),
                      Text("tecnocomfenalco@edu.co"),
                    ],
                  ),
                ),

                /// 🔵 FOOTER
                Container(
                  padding: const EdgeInsets.all(20),
                  color: const Color(0xFFA3D0F7),
                  child: const Center(
                    child: Text("© 2025 Educational Harmonie"),
                  ),
                )
              ],
            ),
          ),

          /// 💬 BOTÓN CHAT
          Positioned(
            bottom: 20,
            right: 20,
            child: chatVisible
                ? const SizedBox()
                : FloatingActionButton.extended(
                    backgroundColor: const Color(0xFF1976D2),
                    onPressed: () {
                      setState(() {
                        chatVisible = true;
                      });
                    },
                    label: const Text("Asistente"),
                    icon: const Icon(Icons.headset),
                  ),
          ),

          /// 💬 CHAT
          if (chatVisible)
            Positioned(
              bottom: 80,
              right: 20,
              child: Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2), blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [

                    Container(
                      padding: const EdgeInsets.all(10),
                      color: const Color(0xFF1976D2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Asistente",
                              style: TextStyle(color: Colors.white)),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                chatVisible = false;
                              });
                            },
                          )
                        ],
                      ),
                    ),

                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(10),
                        children: mensajes.map((m) {
                          bool esUsuario = m["tipo"] == "user";
                          return Align(
                            alignment: esUsuario
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: esUsuario
                                    ? Colors.blue
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(m["texto"]!),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: chatController,
                            decoration: const InputDecoration(
                              hintText: "Escribe...",
                              contentPadding: EdgeInsets.all(10),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: enviarMensaje,
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _card(String titulo, String texto) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
        ],
      ),
      child: Column(
        children: [
          Text(titulo,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(texto, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}