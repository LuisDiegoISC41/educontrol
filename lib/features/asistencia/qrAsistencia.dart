import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class QRAsistenciaScreen extends StatefulWidget {
  final int idGrupo;
  final int idDocente;

  const QRAsistenciaScreen({
    super.key,
    required this.idGrupo,
    required this.idDocente,
  });

  @override
  State<QRAsistenciaScreen> createState() => _QRAsistenciaScreenState();
}

class _QRAsistenciaScreenState extends State<QRAsistenciaScreen> {
  String? qrToken;
  int? idSesion;
  bool qrExpirado = false;

  @override
  void initState() {
    super.initState();
    _verificarSesionDelDia();
  }

  // Función para verificar si ya hay una sesión activa hoy
  Future<void> _verificarSesionDelDia() async {
    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);

    final response = await Supabase.instance.client
        .from('sesionclase')
        .select()
        .eq('id_grupo', widget.idGrupo)
        .gte('fecha', hoy.toIso8601String())
        .order('fecha', ascending: false)
        .limit(1);

    if (response.isNotEmpty) {
      final sesion = response.first;
      final DateTime fechaSesion = DateTime.parse(sesion['fecha']);
      final Duration diferencia = now.difference(fechaSesion);

      if (diferencia.inMinutes < 3) {
        // Aún es válida
        setState(() {
          qrToken = sesion['qr_token'];
          idSesion = sesion['id_sesion'];
          qrExpirado = false;
        });
      } else {
        // Ya expiró el QR
        setState(() {
          qrExpirado = true;
          qrToken = null;
          idSesion = null;
        });

        await _marcarFaltasAutomaticas(sesion['id_sesion'], hoy, now);
      }
    } else {
      // No hay sesión hoy
      setState(() {
        qrExpirado = false;
        qrToken = null;
        idSesion = null;
      });
    }
  }

  Future<void> _marcarFaltasAutomaticas(int idSesion, DateTime hoy, DateTime now) async {
    // Obtener los alumnos del grupo
    final alumnos = await Supabase.instance.client
        .from('alumno_grupo')
        .select('id_alumno')
        .eq('id_grupo', widget.idGrupo);

    for (final alumno in alumnos) {
      final existeAsistencia = await Supabase.instance.client
          .from('asistencia')
          .select()
          .eq('id_sesion', idSesion)
          .eq('id_alumno', alumno['id_alumno'])
          .maybeSingle();

      if (existeAsistencia == null) {
        await Supabase.instance.client.from('asistencia').insert({
          'id_sesion': idSesion,
          'id_alumno': alumno['id_alumno'],
          'estado': 'Falta',
          'fecha': hoy.toIso8601String().substring(0, 10), // solo fecha
          'fecha_hora': now.toIso8601String(), // fecha + hora local
        });
      }
    }
  }

  Future<void> _generarNuevoQR() async {
    final now = DateTime.now();
    final hoy = DateTime(now.year, now.month, now.day);

    // Verifica si ya existe una sesión hoy
    final existe = await Supabase.instance.client
        .from('sesionclase')
        .select()
        .eq('id_grupo', widget.idGrupo)
        .gte('fecha', hoy.toIso8601String())
        .maybeSingle();

    if (existe != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya se generó un QR hoy para este grupo')),
      );
      return;
    }

    final nuevoQr = const Uuid().v4();
    final nuevaSesion = await Supabase.instance.client
        .from('sesionclase')
        .insert({
          'id_grupo': widget.idGrupo,
          'fecha': now.toIso8601String(), // fecha + hora local
          'qr_token': nuevoQr,
          'creada_por': widget.idDocente,
        })
        .select();

    if (nuevaSesion.isNotEmpty) {
      setState(() {
        qrToken = nuevoQr;
        idSesion = nuevaSesion.first['id_sesion'];
        qrExpirado = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al generar QR')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR de Asistencia')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (qrToken != null) ...[
              const Text(
                'Código QR generado:',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              SelectableText(
                qrToken!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
            ] else if (qrExpirado) ...[
              const Text('QR expirado. Ya se asignaron faltas.'),
            ] else ...[
              const Text('No se ha generado ningún QR'),
            ],
            ElevatedButton(
              onPressed: _generarNuevoQR,
              child: const Text('Generar QR'),
            ),
          ],
        ),
      ),
    );
  }
}
