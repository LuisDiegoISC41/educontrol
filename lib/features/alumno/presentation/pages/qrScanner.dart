import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EscanearQRScreen extends StatefulWidget {
  final int idAlumno;
  const EscanearQRScreen({super.key, required this.idAlumno});

  @override
  _EscanearQRScreenState createState() => _EscanearQRScreenState();
}

class _EscanearQRScreenState extends State<EscanearQRScreen> {
  bool isProcessing = false;
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> agregarAlumnoAGrupo(int idGrupo) async {
    try {
      await Supabase.instance.client.from('alumno_grupo').insert({
        'id_alumno': widget.idAlumno,
        'id_grupo': idGrupo,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Te uniste al grupo exitosamente!')),
      );
      Navigator.pop(context); // Cerrar pantalla al finalizar
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al unirse al grupo: $e')),
      );
      isProcessing = false;
      controller.start();
    }
  }

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;
    isProcessing = true;

    final String? code = capture.barcodes.first.rawValue;
    if (code != null) {
      try {
        controller.stop();

        final data = jsonDecode(code);
        final idGrupo = data['id_grupo'];
        if (idGrupo == null || (idGrupo is! int && idGrupo is! String)) {
          throw Exception("QR no contiene un id_grupo válido");
        }

        final int id = idGrupo is int ? idGrupo : int.tryParse(idGrupo.toString()) ?? 0;
        if (id == 0) throw Exception("id_grupo inválido en QR");

        await agregarAlumnoAGrupo(id);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('QR inválido: $e')),
        );

        await Future.delayed(const Duration(seconds: 3));
        isProcessing = false;
        controller.start();
      }
    } else {
      isProcessing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escanear QR del Grupo")),
      body: MobileScanner(
        controller: controller,
        onDetect: onDetect,
      ),
    );
  }
}
