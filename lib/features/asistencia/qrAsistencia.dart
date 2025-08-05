import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QrAsistenciaScreen extends StatefulWidget {
  final int idAlumno;

  const QrAsistenciaScreen({super.key, required this.idAlumno});

  @override
  _QrAsistenciaScreenState createState() => _QrAsistenciaScreenState();
}

class _QrAsistenciaScreenState extends State<QrAsistenciaScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isProcessing = false;

  Future<void> registrarAsistencia(String token) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    final supabase = Supabase.instance.client;

    try {
      final now = DateTime.now(); // Fecha local

      // Buscar sesión por token
      final session = await supabase
          .from('sesion_clase')
          .select('id_sesion, id_grupo, fecha')
          .eq('qr_token', token)
          .maybeSingle();

      if (session == null) {
        throw 'Código QR inválido o expirado';
      }

      final sessionDate = DateTime.parse(session['fecha']);
      final sessionDay = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);
      final today = DateTime(now.year, now.month, now.day);

      if (sessionDay != today) {
        throw 'Código QR no válido para hoy';
      }

      final String idSesion = session['id_sesion'];
      final int idGrupo = session['id_grupo'];

      // Verificar si alumno pertenece al grupo
      final pertenece = await supabase
          .from('alumno_grupo')
          .select()
          .eq('id_alumno', widget.idAlumno)
          .eq('id_grupo', idGrupo)
          .maybeSingle();

      if (pertenece == null) {
        throw 'No perteneces a este grupo';
      }

      // Verificar si ya registró asistencia
      final asistenciaExistente = await supabase
          .from('asistencia')
          .select('id_asistencia')
          .eq('id_alumno', widget.idAlumno)
          .eq('id_sesion', idSesion)
          .maybeSingle();

      if (asistenciaExistente != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ya registraste tu asistencia')),
        );
      } else {
        // Insertar asistencia
        await supabase.from('asistencia').insert({
          'estado': 'Asistencia',
          'fecha': now.toIso8601String().substring(0, 10),
          'fecha_hora': now.toIso8601String(),
          'id_alumno': widget.idAlumno,
          'id_sesion': idSesion,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asistencia registrada con éxito')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR para Asistencia'),
        backgroundColor: const Color(0xFF0A0C2A),
      ),
      body: MobileScanner(
        controller: controller,
        onDetect: (capture) async {
          if (isProcessing) return;  // evita múltiples procesos simultáneos

          final barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final String? code = barcode.rawValue;
            if (code != null) {
              await registrarAsistencia(code);
              break; // solo procesa el primero para evitar repeticiones
            }
          }
        },
      ),
    );
  }
}
