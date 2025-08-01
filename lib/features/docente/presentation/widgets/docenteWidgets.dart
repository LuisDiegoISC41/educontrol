import 'package:flutter/material.dart';
import 'package:educontrol/features/asistencia/presentation/pages/asistenciados.dart';

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AttendanceScreen(grupo: title),
                          ),
                        );
                      },
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