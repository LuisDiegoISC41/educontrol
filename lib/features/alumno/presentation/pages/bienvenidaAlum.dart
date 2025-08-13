import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../asistencia/EscanearQrAsistencia.dart';
import '../../../asistencia/asistencia.dart';
import 'qrScanner.dart'; // Pantalla para registrar a un grupo
import '../widgets/alumnoWidgets.dart';
import '../../../../login.dart'; // Asegúrate de ajustar la ruta de tu LoginPage

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
          .select('fecha_ingreso, grupo(id_grupo, nombre)')
          .eq('id_alumno', idAlumno!)
          .order('fecha_ingreso', ascending: false);

      print('Respuesta de clases: $response');

      setState(() {
        subjects = (response as List)
            .map((e) => {
                  'idGrupo': e['grupo']['id_grupo'], // idGrupo
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

      // Drawer de menú lateral
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF8D22B1),
              ),
              child: Text(
                'Alumno',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Cerrar sesión'),
              onTap: () async {
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(tipo: ""),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),

      // AppBar con botón para abrir el Drawer
      appBar: AppBar(
        backgroundColor: const Color(0xFF160537),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        elevation: 0,
      ),

      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                          builder: (context) => AsistenciasScreen(
                                            materia: subject['name'],
                                            idAlumno: idAlumno!,
                                            idGrupo: subject['idGrupo'],
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
                                EscanearQrAsistencia(idAlumno: idAlumno!),
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
