import 'package:flutter/material.dart';
import 'package:educontrol/features/grupo/presentation/pages/agregarGrupo.dart';
import 'package:educontrol/features/grupo/data/models/grupoModels.dart';
import '../../domain/usecases/docenteInfo.dart';
import '../../data/datasources/docenteData.dart';
import '../../data/repositories/docenteRepoIm.dart';
import '../widgets/docenteWidgets.dart';

class WelcomePage extends StatefulWidget {
  final int idDocente;
  const WelcomePage({super.key, required this.idDocente});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<GrupoModel> grupos = [];
  bool isLoading = true;

  late final GetGruposByDocente getGruposByDocente;

  @override
  void initState() {
    super.initState();
    final repo = DocenteRepositoryImpl(DocenteRemoteDataSource());
    getGruposByDocente = GetGruposByDocente(repo);
    _cargarGrupos();
  }

  Future<void> _cargarGrupos() async {
    setState(() => isLoading = true);
    try {
      final data = await getGruposByDocente(widget.idDocente);
      setState(() {
        grupos = data.map((g) => GrupoModel.fromMap(g)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar grupo en bienvenida doc: $e')),
      );
    }
  }

  Future<void> _agregarGrupo() async {
    final nuevoGrupo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevoGrupoScreen(idDocente: widget.idDocente),
      ),
    );
    if (nuevoGrupo != null && nuevoGrupo is GrupoModel) {
      // Después de insertar, recargar desde la BD
      await _cargarGrupos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '¡Bienvenido!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://i.imgur.com/DBvYQpY.png',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                  ),
                  onPressed: _agregarGrupo,
                  child: Column(
                    children: [
                      Image.network(
                        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Grupo123',
                        height: 150,
                        width: 150,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Generar Grupo',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : grupos.isEmpty
                        ? const Center(
                            child: Text(
                              'No tienes grupos aún.',
                              style: TextStyle(color: Colors.white70),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: grupos.map((grupo) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: SubjectCard(
                                    title: grupo.nombre,
                                    qrGrupo: grupo.idGrupo.toString(),
                                    code: grupo.grupo,
                                    color: const Color(0xFF2D0C3F),
                                    iconUrl: 'https://img.icons8.com/color/96/conference-call.png',
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
