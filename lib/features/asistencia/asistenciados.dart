import 'package:flutter/material.dart';

class AttendanceScreen extends StatefulWidget {
  final String grupo; // Para identificar el grupo (opcional)
  const AttendanceScreen({super.key, required this.grupo});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<bool> attendance = List.generate(10, (index) => true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0C2A),
        title: Text('Asistencias - ${widget.grupo}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fecha
              Row(
                children: [
                  Text(
                    'Jueves 17 de Julio',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.purple[200],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.calendar_today, color: Colors.greenAccent, size: 20),
                ],
              ),
              const SizedBox(height: 20),

              // Lista de asistencia
              Expanded(
                child: ListView.builder(
                  itemCount: attendance.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.greenAccent,
                        child: Text('A', style: TextStyle(color: Colors.black)),
                      ),
                      title: Text('Alumno ${index + 1}'),
                      trailing: Checkbox(
                        value: attendance[index],
                        onChanged: (value) {
                          setState(() {
                            attendance[index] = value!;
                          });
                        },
                        checkColor: Colors.white,
                        activeColor: Colors.deepPurpleAccent,
                      ),
                    );
                  },
                ),
              ),

              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        attendance = List.generate(attendance.length, (index) => false);
                      });
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Guardar asistencia
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Asistencia guardada')),
                      );
                    },
                    child: const Text(
                      'Guardar',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
