import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asistencias',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<bool> attendance = List.generate(10, (index) => true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0C2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Asistencias',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/avatar.png'), // Usa tu imagen aquí
                    radius: 24,
                  ),
                ],
              ),
              SizedBox(height: 16),

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
                  SizedBox(width: 8),
                  Icon(Icons.calendar_today, color: Colors.greenAccent, size: 20),
                ],
              ),
              SizedBox(height: 20),

              // Lista
              Expanded(
                child: ListView.builder(
                  itemCount: attendance.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.greenAccent,
                        child: Text('A', style: TextStyle(color: Colors.black)),
                      ),
                      title: Text('List item'),
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
                        attendance = List.generate(10, (index) => false);
                      });
                    },
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Aquí podrías guardar la asistencia
                    },
                    child: Text(
                      'Guardar',
                      style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}