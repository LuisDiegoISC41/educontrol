import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../asistencia/asistencia.dart';
import 'qrScanner.dart'; // Pantalla para registrar a un grupo
import '../../../asistencia/qrAsistencia.dart'; // Nueva pantalla para registrar asistencia
import '../widgets/alumnoWidgets.dart';

class BienvenidaAlu extends StatefulWidget {
  final String nombreCompleto;
  final String matricula;

  const BienvenidaAlu({
    super.key,
    required this.nombreCompleto,
    required this.matricula,
  });

  @override
  _BienvenidaAluState createState() => _BienvenidaAluState();
}

class _BienvenidaAluState extends State<BienvenidaAlu> {
  bool showScanner = false;
  int? idAlumno; // ID cargado desde Supabase
  bool cargando = true;

  List<Map<String, dynamic>> subjects = [];

  @override
  void initState() {
    super.initState();
    _cargarIdAlumno();
  }

  Future<void> _cargarIdAlumno() async {
    try {
      final response = await Supabase.instance.client
          .from('alumno')
          .select('id_alumno')
          .eq('matricula', widget.matricula)
          .maybeSingle();

      if (response != null) {
        setState(() {
          idAlumno = response['id_alumno'] as int;
        });
        print('ID alumno encontrado: $idAlumno');
        await _cargarClases();
      } else {
        print('No se encontró el alumno');
        setState(() {
          cargando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el alumno')),
        );
      }
    } catch (e, s) {
      print('Error en _cargarIdAlumno: $e');
      print(s);
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el alumno: $e')),
      );
    }
  }

  Future<void> _cargarClases() async {
    if (idAlumno == null) return;

    try {
      final response = await Supabase.instance.client
          .from('alumno_grupo')
          .select('fecha_ingreso, grupo(nombre)')
          .eq('id_alumno', idAlumno!);

      print('Respuesta de clases: $response');

      setState(() {
        subjects = (response as List)
            .map((e) => {
                  'name': e['grupo']['nombre'] as String,
                  'date': e['fecha_ingreso'] != null
                      ? (e['fecha_ingreso'] as String).split('T').first
                      : '',
                })
            .toList();
        cargando = false;
      });
    } catch (e, s) {
      print('Error en _cargarClases: $e');
      print(s);
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar las clases: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF210A4E),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFF160537),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(22.5),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(Icons.person,
                              color: Colors.white, size: 24),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.nombreCompleto,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Estudiante - ${widget.matricula}',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF8D22B1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: subjects.isEmpty
                            ? const Center(
                                child: Text(
                                  'No hay clases registradas',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              )
                            : ListView.builder(
                                itemCount: subjects.length,
                                itemBuilder: (context, index) {
                                  final subject = subjects[index];
                                  return SubjectCard(
                                    name: subject['name'],
                                    date: subject['date'],
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AsistenciasScreen(
                                            materia: subject['name'],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (idAlumno == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No se pudo obtener el ID del alumno')),
            );
            return;
          }

          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.group_add),
                      title: const Text('Registrar a un grupo'),
                      onTap: () async {
                        Navigator.pop(context);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EscanearQRScreen(idAlumno: idAlumno!),
                          ),
                        );
                        await _cargarClases();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.qr_code),
                      title: const Text('Registrar asistencia'),
                      onTap: () async {
                        Navigator.pop(context);
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QrAsistenciaScreen(idAlumno: idAlumno!),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: const Color(0xFFD946EF),
        elevation: 12,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
      ),
    );
  }
}
