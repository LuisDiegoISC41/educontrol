import 'package:flutter/material.dart';
import 'package:educontrol/features/grupo/agregarGrupo.dart';
import 'package:educontrol/features/grupo/models/grupoModels.dart';
import 'package:educontrol/core/database/appBD.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomePage(idDocente: 1), // Cambia el idDocente según corresponda
  ));
}

class WelcomePage extends StatefulWidget {
  final int idDocente;
  const WelcomePage({super.key, required this.idDocente});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  List<GrupoModel> grupos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarGrupos();
  }

  Future<void> _cargarGrupos() async {
    setState(() => isLoading = true);
    final data = await appBD.client
        .from('grupo')
        .select()
        .eq('id_docente', widget.idDocente);
    setState(() {
      grupos = (data as List)
          .map((g) => GrupoModel.fromMap(g as Map<String, dynamic>))
          .toList();
      isLoading = false;
    });
  }

  Future<void> _agregarGrupo() async {
    final nuevoGrupo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NuevoGrupoScreen(idDocente: widget.idDocente),
      ),
    );
    if (nuevoGrupo != null && nuevoGrupo is GrupoModel) {
      setState(() {
        grupos.add(nuevoGrupo);
      });
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
              // Encabezado
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

              // Botón para agregar nuevo grupo
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

              // Lista dinámica de grupos
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
                                    code: grupo.qr,
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

class SubjectCard extends StatelessWidget {
  final String title;
  final String code;
  final Color color;
  final String iconUrl;

  const SubjectCard({
    super.key,
    required this.title,
    required this.code,
    required this.color,
    required this.iconUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  code,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFAA),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Ver QR"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00FFAA),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Listas"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Image.network(
            iconUrl,
            height: 60,
            width: 60,
          ),
        ],
      ),
    );
  }
}