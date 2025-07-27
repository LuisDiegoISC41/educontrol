import 'package:flutter/material.dart';
import 'package:educontrol/grupo/agregarGrupo.dart';
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomePage(),
  ));
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://i.imgur.com/DBvYQpY.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contenido principal en Expanded
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // QR Code y botón
                      // QR Code y botón
                      Center(
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.all(12),
                              ),
                              onPressed: () {
                                // Acción al presionar (por ejemplo navegar)
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => NuevoGrupoApp()),

                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Grupo123',
                                    height: 150,
                                    width: 150,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Generar Grupo',
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Search Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Materias
                      SubjectCard(
                        title: 'Programación',
                        code: 'ISC308',
                        color: const Color(0xFF2D0C3F),
                        iconUrl: 'https://img.icons8.com/color/96/conference-call.png',
                      ),
                      const SizedBox(height: 20),
                      SubjectCard(
                        title: 'Redes',
                        code: 'ISC108',
                        color: const Color(0xFF2D0C3F),
                        iconUrl: 'https://img.icons8.com/color/96/networking-manager.png',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String title;
  final String code;
  final Color color;
  final String iconUrl;

  const SubjectCard({
    super.key,
    required this.title,
    required this.code,
    required this.color,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  code,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFAA),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Ver QR"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFAA),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Listas"),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Icono
          Image.network(
            iconUrl,
            height: 60,
            width: 60,
          ),
        ],
      ),
    );
  }
}
