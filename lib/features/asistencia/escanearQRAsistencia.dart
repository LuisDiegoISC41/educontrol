import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EscanearQrAsistencia extends StatefulWidget {
  final int idAlumno;

  const EscanearQrAsistencia({super.key, required this.idAlumno});

  @override
  _EscanearQrAsistenciaState createState() => _EscanearQrAsistenciaState();
}

class _EscanearQrAsistenciaState extends State<EscanearQrAsistencia> {
  final MobileScannerController controller = MobileScannerController();
  bool isProcessing = false;

  Future<void> registrarAsistencia(String token) async {
    if (isProcessing) return;
    setState(() => isProcessing = true);

    final supabase = Supabase.instance.client;

    try {
      // Usar hora local (no UTC)
      final now = DateTime.now();

      // Buscar sesiones válidas con ese token
      final sesiones = await supabase
          .from('sesion_clase')
          .select('id_sesion, id_grupo, fecha')
          .eq('qr_token', token);

      if (sesiones.isEmpty) {
        throw 'Código QR inválido o no existe';
      }

      final session = sesiones.first;
      final sessionDate = DateTime.parse(session['fecha']); // hora local aquí
      final segundos = now.difference(sessionDate).inSeconds;

      final String idSesion = session['id_sesion'];
      final int idGrupo = session['id_grupo'];

      // Guardar fecha + hora actual en ISO 8601 local
      final String fechaHoraStr = now.toIso8601String();

      // Verificar si el alumno pertenece al grupo
      final pertenece = await supabase
          .from('alumno_grupo')
          .select()
          .eq('id_alumno', widget.idAlumno)
          .eq('id_grupo', idGrupo)
          .maybeSingle();

      if (pertenece == null) {
        throw 'No perteneces a este grupo';
      }

      // Verificar si ya hay una asistencia en esa sesión
      final asistenciasExistentes = await supabase
          .from('asistencia')
          .select()
          .eq('id_alumno', widget.idAlumno)
          .eq('id_sesion', idSesion);

      if (asistenciasExistentes.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ya habías registrado tu asistencia')),
        );
        Navigator.pop(context);
        return;
      }

      // Determinar estado de asistencia
      String estado;
      if (segundos < 60) {
        estado = 'Asistencia';
      } else if (segundos < 120) {
        estado = 'Retardo';
      } else if (segundos <= 180) {
        estado = 'Falta';
      } else {
        estado = 'Falta';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El QR ya expiró. Registrado como Falta')),
        );
      }

      // Registrar asistencia con fecha y hora actual (local)
      await supabase.from('asistencia').insert({
        'estado': estado,
        'fecha': fechaHoraStr.substring(0, 10), // solo fecha YYYY-MM-DD
        'fecha_hora': fechaHoraStr, // fecha + hora local
        'id_alumno': widget.idAlumno,
        'id_sesion': idSesion,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$estado registrada correctamente')),
      );

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
