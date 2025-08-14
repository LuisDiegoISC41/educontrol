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
      backgroundColor: const Color(0xFF080E2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080E2A),
        centerTitle: true, // Centra el título
        title: const Text(
          'Código QR del Grupo',
          style: TextStyle(
            color: Colors.white, // Título en blanco
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // Flecha de regreso en purpleAccent
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF080E2A),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
                foregroundColor: Colors.white, // QR blanco
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ID del grupo: $idGrupo',
              style: const TextStyle(
                color: Colors.purpleAccent, // Texto en purpleAccent
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}