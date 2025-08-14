import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../asistencia.dart';
import '../../todasAsistencias.dart'; // <-- AJUSTA la ruta si es necesario (y el nombre de la clase abajo)

class AttendanceScreen extends StatefulWidget {
  final String grupo; // Para identificar el grupo por nombre
  final int idDocente; // Id del docente que crea la sesión

  const AttendanceScreen({super.key, required this.grupo, required this.idDocente});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<Map<String, dynamic>> alumnos = [];
  List<bool> attendance = [];
  bool cargando = true;
  int? idGrupo; // <-- Guardaremos aquí el idGrupo para reutilizarlo

  // Fecha seleccionada mostrada en la UI
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _cargarAlumnos();
  }

  Future<void> _cargarAlumnos() async {
    final supabase = Supabase.instance.client;

    try {
      final grupoRes = await supabase
          .from('grupo')
          .select('id_grupo')
          .eq('nombre', widget.grupo)
          .maybeSingle();

      if (grupoRes == null) {
        throw 'Grupo no encontrado';
      }

      idGrupo = grupoRes['id_grupo'];

      if (idGrupo == null) throw 'ID de grupo es null';

      final response = await supabase
          .from('alumno_grupo')
          .select('alumno(id_alumno, nombre, matricula)')
          .eq('id_grupo', idGrupo!);

      final listaAlumnos = (response as List).map((e) {
        return {
          'id_alumno': e['alumno']['id_alumno'],
          'nombre': e['alumno']['nombre'],
          'matricula': e['alumno']['matricula'],
        };
      }).toList();

      setState(() {
        alumnos = listaAlumnos;
        attendance = List.generate(alumnos.length, (index) => false);
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar alumnos: $e')),
      );
    }
  }

  Future<void> generarQRTemporal() async {
    final supabase = Supabase.instance.client;

    try {
      if (idGrupo == null) throw 'ID de grupo no disponible';

      final ahora = DateTime.now(); // Ahora local, sin .toUtc()

      // Consultar última sesión creada para ese grupo
      final sesiones = await supabase
          .from('sesion_clase')
          .select()
          .eq('id_grupo', idGrupo!)
          .order('fecha', ascending: false)
          .limit(1);

      Map<String, dynamic>? sesionExistente;

      if (sesiones.isNotEmpty) {
        final sesion = sesiones.first;
        final fechaSesion = DateTime.parse(sesion['fecha']); // Ahora local

        final diferencia = ahora.difference(fechaSesion);
        if (diferencia.inMinutes < 10) {
          // Ya hay QR válido
          sesionExistente = sesion;
        }
      }

      String qrToken;

      if (sesionExistente != null) {
        qrToken = sesionExistente['qr_token'];
      } else {
        // Generar nuevo QR token
        qrToken = '${idGrupo}_${ahora.millisecondsSinceEpoch}';

        await supabase.from('sesion_clase').insert({
          'id_grupo': idGrupo,
          'fecha': ahora.toIso8601String(), // Ahora local al guardar
          'qr_token': qrToken,
          'creada_por': widget.idDocente,
        });
      }

      // Mostrar QR
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Código QR'),
          content: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                QrImageView(
                  data: qrToken,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
                const SizedBox(height: 10),
                const Text('Válido por 10 minutos'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR disponible por 10 minutos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar QR: $e')),
      );
    }
  }

  String _formatearFecha(DateTime fecha) {
    const diasSemana = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    final diaSemana = diasSemana[fecha.weekday % 7];
    final dia = fecha.day;
    final mes = meses[fecha.month - 1];
    return '$diaSemana $dia de $mes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0C2A),
        title: Text('Asistencias - ${widget.grupo}',
        style: const TextStyle(color: Colors.white),

        ),
        actions: [
          // 🔹 Nuevo botón de LISTA al lado del QR
          IconButton(
            icon: const Icon(Icons.list_alt, color: Colors.blueAccent),
            tooltip: 'Ver todas las asistencias',
            onPressed: () {
              if (idGrupo == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Aún no se ha cargado el grupo')),
                );
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TodasAsistenciasPage(
                    idDocente: widget.idDocente,
                    qrGrupo: idGrupo!.toString(), // pasamos el idGrupo como String
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.greenAccent),
            tooltip: 'Generar QR',
            onPressed: () async {
              await generarQRTemporal();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fecha seleccionada
              Center(
                child: Text(
                  _formatearFecha(_fechaSeleccionada),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.purple[200],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: cargando
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: alumnos.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.greenAccent,
                              child: Text('A', style: TextStyle(color: Colors.black)),
                            ),
                            title: Text(alumnos[index]['nombre'], style: const TextStyle(color: Colors.white)),
                            subtitle: Text('Matrícula: ${alumnos[index]['matricula']}', style: const TextStyle(color: Colors.white70)),
                            
                            onTap: () {
                              if (idGrupo == null) return; // Seguridad por si no cargó el grupo aún
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AsistenciasScreen(
                                    materia: alumnos[index]['nombre'],
                                    idAlumno: alumnos[index]['id_alumno'],
                                    idGrupo: idGrupo!,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),        
            ],
          ),
        ),
      ),
    );
  }
}
