import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class VerQRGrupoScreen extends StatelessWidget {
  final int idGrupo;

  const VerQRGrupoScreen({super.key, required this.idGrupo});

  @override
  Widget build(BuildContext context) {
    // Generamos el JSON del QR
    final qrData = jsonEncode({"id_grupo": idGrupo});

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 104, 104, 182),
      appBar: AppBar(
        title: const Text('Código QR del Grupo'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImageView(
              data: qrData,
              version: QrVersions.auto,
              size: 200.0,
            ),
            const SizedBox(height: 20),
            Text(
              'ID del grupo: $idGrupo',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
