import 'package:flutter/material.dart';
import 'package:educontrol/features/grupo/data/models/grupoModels.dart';
import 'package:educontrol/core/database/appBD.dart';

class NuevoGrupoScreen extends StatefulWidget {
  final int idDocente; // Recibe el id del docente

  const NuevoGrupoScreen({super.key, required this.idDocente});

  @override
  State<NuevoGrupoScreen> createState() => _NuevoGrupoScreenState();
}

class _NuevoGrupoScreenState extends State<NuevoGrupoScreen> {
  final TextEditingController claseController = TextEditingController();
  final TextEditingController grupoController = TextEditingController();
  bool isLoading = false;

  Future<void> agregarGrupo() async {
    final nombre = claseController.text.trim();
    final grupoN= grupoController.text.trim();

    if (nombre.isEmpty || grupoN.isEmpty) return;
    final qrGrupo = "${nombre.toLowerCase()}${grupoN.toLowerCase()}";
    setState(() => isLoading = true);

    final grupo = GrupoModel(
      nombre: nombre,
      grupo: grupoN,
      idDocente: widget.idDocente,
      qrGrupo: qrGrupo,
    );

    try {
      await appBD.client.from('grupo').insert(grupo.toMap());
      Navigator.pop(context, grupo);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar grupo: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '¿Nuevo grupo?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B3A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Crea un nuevo grupo',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: claseController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Clase',
                          labelStyle: const TextStyle(color: Colors.purpleAccent),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: grupoController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Grupo',
                          labelStyle: const TextStyle(color: Colors.purpleAccent),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar', style: TextStyle(color: Colors.greenAccent)),
                          ),
                          const SizedBox(width: 16),
                          TextButton(
                            onPressed: isLoading ? null : agregarGrupo,
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Agregar', style: TextStyle(color: Colors.greenAccent)),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
