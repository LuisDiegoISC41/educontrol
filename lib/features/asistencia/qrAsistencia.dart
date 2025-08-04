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
      final now = DateTime.now().toUtc();

      // 1. Buscar sesión por token
      final session = await supabase
          .from('sesion_clase')
          .select('id_sesion, id_grupo, fecha')
          .eq('qr_token', token)
          .maybeSingle();

      if (session == null) {
        throw 'Código QR inválido o expirado';
      }

      final sessionDate = DateTime.parse(session['fecha']).toUtc();
      final sessionDay = DateTime(sessionDate.year, sessionDate.month, sessionDate.day);
      final today = DateTime(now.year, now.month, now.day);

      if (sessionDay != today) {
        throw 'Código QR no válido para hoy';
      }

      final String idSesion = session['id_sesion'];
      final int idGrupo = session['id_grupo'];

      // 2. Verificar si el alumno pertenece al grupo
      final pertenece = await supabase
          .from('alumno_grupo')
          .select()
          .eq('id_alumno', widget.idAlumno)
          .eq('id_grupo', idGrupo)
          .maybeSingle();

      if (pertenece == null) {
        throw 'No perteneces a este grupo';
      }

      // 3. Verificar si ya registró asistencia en esta sesión
      final asistenciaExistente = await supabase
          .from('asistencia')
          .select('id_asistencia')
          .eq('id_alumno', widget.idAlumno)
          .eq('id_sesion', idSesion)
          .maybeSingle();

      if (asistenciaExistente != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ya habías registrado tu asistencia')),
        );
      } else {
        // 4. Insertar asistencia con fecha y hora exactas
        await supabase.from('asistencia').insert({
          'estado': 'Asistencia',
          'fecha': sessionDay.toIso8601String().substring(0, 10),
          'fecha_hora': now.toIso8601String(),
          'id_alumno': widget.idAlumno,
          'id_sesion': idSesion,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asistencia registrada correctamente')),
        );
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isProcessing = false);
    }
  }

  Future<void> onDetect(BarcodeCapture capture) async {
    if (isProcessing) return;
    final String? code = capture.barcodes.first.rawValue;
    if (code == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR vacío')),
      );
      return;
    }
    await registrarAsistencia(code);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR de Asistencia')),
      body: MobileScanner(
        controller: controller,
        onDetect: onDetect,
      ),
    );
  }
}
