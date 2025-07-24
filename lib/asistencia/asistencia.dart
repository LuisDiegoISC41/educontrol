
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: AsistenciasScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AsistenciasScreen extends StatefulWidget {
  const AsistenciasScreen({super.key});

  @override
  State<AsistenciasScreen> createState() => _AsistenciasScreenState();
}

class _AsistenciasScreenState extends State<AsistenciasScreen> {
  final List<String> fechas = [
    "Jueves 17 de Julio",
    "Viernes 18 de Julio",
    "Lunes 21 de Julio",
    "Martes 22 de Julio",
    "Miércoles 23 de Julio",
    "Jueves 24 de Julio",
    "Viernes 25 de Julio",
    "Lunes 28 de Julio",
    "Martes 29 de Julio",
    "Miércoles 30 de Julio",
  ];

  final List<bool> asistencias = List.generate(10, (index) => true)..[3] = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Asistencias',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/avatar.png'), // Coloca aquí tu imagen
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Inglés',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: fechas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.greenAccent,
                        child: Text(
                          'A',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      title: Text(
                        fechas[index],
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Checkbox(
                        value: asistencias[index],
                        onChanged: (value) {
                          setState(() {
                            asistencias[index] = value!;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        activeColor: Colors.greenAccent,
                        checkColor: Colors.black,
                        side: const BorderSide(color: Colors.purpleAccent),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      // Acción de cancelar
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Acción de guardar
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
