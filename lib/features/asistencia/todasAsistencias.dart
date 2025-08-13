import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TodasAsistenciasPage extends StatefulWidget {
  final int idDocente;
  final String qrGrupo; // ID del grupo en texto

  const TodasAsistenciasPage({
    Key? key,
    required this.idDocente,
    required this.qrGrupo,
  }) : super(key: key);

  @override
  State<TodasAsistenciasPage> createState() => _TodasAsistenciasPageState();
}

class _TodasAsistenciasPageState extends State<TodasAsistenciasPage> {
  List<Map<String, dynamic>> asistencias = [];
  List<String> fechas = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAsistencias();
  }

  Future<void> fetchAsistencias() async {
    try {
      final supabase = Supabase.instance.client;

      final alumnosGrupo = await supabase
          .from('alumno_grupo')
          .select('alumno(id_alumno, nombre, apellido_paterno, apellido_materno)')
          .eq('id_grupo', int.parse(widget.qrGrupo));

      List<Map<String, dynamic>> listaAlumnos = [];

      for (var ag in alumnosGrupo) {
        final alumno = ag['alumno'];
        if (alumno != null) {
          final asistenciasAlumno = await supabase
              .from('asistencia')
              .select('fecha, estado, sesion_clase(id_grupo)')
              .eq('id_alumno', alumno['id_alumno']);

          final asistenciasFiltradas = asistenciasAlumno
              .where((a) =>
                  a['sesion_clase'] != null &&
                  a['sesion_clase']['id_grupo'] == int.parse(widget.qrGrupo))
              .toList();

          listaAlumnos.add({
            'id_alumno': alumno['id_alumno'],
            'nombre': alumno['nombre'],
            'apellido_paterno': alumno['apellido_paterno'],
            'apellido_materno': alumno['apellido_materno'],
            'asistencia': asistenciasFiltradas,
          });
        }
      }

      Set<String> fechasSet = {};
      for (var alumno in listaAlumnos) {
        for (var a in alumno['asistencia']) {
          fechasSet.add(a['fecha']);
        }
      }
      List<String> fechasOrdenadas = fechasSet.toList()..sort();

      setState(() {
        asistencias = listaAlumnos;
        fechas = fechasOrdenadas;
        loading = false;
      });
    } catch (e) {
      print("Error al obtener asistencias: $e");
      setState(() => loading = false);
    }
  }

  Icon _getIconoEstado(String? estado) {
    switch (estado) {
      case 'Asistencia':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'Retardo':
        return const Icon(Icons.access_time, color: Colors.orange);
      case 'Falta':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todas las asistencias"),
        backgroundColor: Colors.blue,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : asistencias.isEmpty
              ? const Center(child: Text("No hay asistencias registradas"))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        const DataColumn(label: Text("Alumno")),
                        ...fechas.map((f) => DataColumn(label: Text(f))),
                      ],
                      rows: asistencias.map((alumno) {
                        final nombreCompleto =
                            "${alumno['nombre']} ${alumno['apellido_paterno']} ${alumno['apellido_materno']}";
                        return DataRow(
                          cells: [
                            DataCell(Text(nombreCompleto)),
                            ...fechas.map((fecha) {
                              final asistenciaDia = (alumno['asistencia'] as List)
                                  .cast<Map<String, dynamic>>()
                                  .firstWhere(
                                      (a) => a['fecha'] == fecha,
                                      orElse: () => {});
                              final estado = asistenciaDia.isNotEmpty
                                  ? asistenciaDia['estado']
                                  : null;
                              return DataCell(_getIconoEstado(estado));
                            }),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
    );
  }
}
