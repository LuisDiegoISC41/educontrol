import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../asistencia/EscanearQrAsistencia.dart';
import '../../../asistencia/asistencia.dart';
import 'qrScanner.dart';
import '../../../../login.dart'; // Ajusta la ruta si es necesario

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
  int? idAlumno;
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
        await _cargarClases();
      } else {
        setState(() {
          cargando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontró el alumno')),
        );
      }
    } catch (e) {
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

      setState(() {
        subjects = (response as List)
            .map((e) => {
                  'idGrupo': e['grupo']['id_grupo'],
                  'name': e['grupo']['nombre'] as String,
                  'date': e['fecha_ingreso'] != null
                      ? (e['fecha_ingreso'] as String).split('T').first
                      : '',
                })
            .toList();
        cargando = false;
      });
    } catch (e) {
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
      backgroundColor: const Color(0xFF080E2A),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: const Color(0xFF080E2A),
              ),
              child: const Text(
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

      appBar: AppBar(
        backgroundColor: const Color(0xFF080E2A),
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
                  // Encabezado
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: const Color(0xFF080E2A),
                    child: const Center(
                      child: Text(
                        "¡Bienvenido!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Datos del alumno
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        Text(widget.nombreCompleto,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Estudiante - ${widget.matricula}',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 16)),
                      ],
                    ),
                  ),
                  // Lista de materias
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2D0D5E),
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
                            : ListView.separated(
                                itemCount: subjects.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: const Color(0xFF69F0AE),
                                  thickness: 2,
                                  height: 24,
                                ),
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
        backgroundColor: const Color(0xFF69F0AE),
        elevation: 12,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final String name;
  final String date;
  final VoidCallback onTap;

  const SubjectCard({
    super.key,
    required this.name,
    required this.date,
    required this.onTap,
  });

  final String imageUrl =
      'https://img.icons8.com/color/96/000000/book--v1.png';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D0D5E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
            Image.network(
              imageUrl,
              width: 60,
              height: 60,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const SizedBox(
                  width: 60,
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 40,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}