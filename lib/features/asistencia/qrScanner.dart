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
      Navigator.pop(context);
    } catch (e) {
      // Detectar si el error es por clave duplicada
      final mensaje = e.toString().contains('duplicate key')
          ? 'Ya estás registrado en este grupo'
          : 'Error al unirse al grupo: $e';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mensaje)),
      );
    }
  }

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;
    isProcessing = true;

    try {
      final String? code = capture.barcodes.first.rawValue;
      debugPrint("Código QR leído: $code");

      int? idGrupo;

      if (code != null) {
        try {
          final data = jsonDecode(code);
          if (data is Map && data.containsKey('id_grupo')) {
            idGrupo = data['id_grupo'] is int
                ? data['id_grupo']
                : int.tryParse(data['id_grupo'].toString());
          } else if (data is int) {
            idGrupo = data;
          } else if (data is String) {
            idGrupo = int.tryParse(data);
          }
        } catch (_) {
          idGrupo = int.tryParse(code);
        }
      }

      if (idGrupo == null || idGrupo == 0) {
        throw Exception("QR inválido: no se pudo obtener id_grupo");
      }

      await agregarAlumnoAGrupo(idGrupo);
    } catch (e) {
      debugPrint("Error al procesar QR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR inválido: $e')),
      );
    } finally {
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