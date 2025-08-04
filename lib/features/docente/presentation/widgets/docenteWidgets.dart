import 'package:flutter/material.dart';
import 'package:educontrol/features/asistencia/presentation/pages/asistenciados.dart';
import '../../../grupo/presentation/pages/ver_qr_grupo.dart';

class SubjectCard extends StatelessWidget {
  final String title;
  final String code;
  final String qrGrupo; // Recibirá solo el ID como string
  final int idDocente; // Nuevo parámetro para idDocente
  final Color color;
  final String iconUrl;

  const SubjectCard({
    super.key,
    required this.title,
    required this.code,
    required this.qrGrupo,
    required this.idDocente,  // Nuevo parámetro requerido
    required this.color,
    required this.iconUrl,
  });

  int? _obtenerIdGrupo(String qr) {
    print("DEBUG - Valor recibido en qrGrupo: $qr");
    return int.tryParse(qr);
  }

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
                      onPressed: () {
                        final id = _obtenerIdGrupo(qrGrupo);

                        if (id == null || id <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Error: No se pudo obtener el ID del grupo")),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VerQRGrupoScreen(idGrupo: id),
                          ),
                        );
                      },
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
                            builder: (context) => AttendanceScreen(
                              grupo: title,
                              idDocente: idDocente,  // PASAR idDocente aquí
                            ),
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
