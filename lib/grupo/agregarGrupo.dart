import 'package:flutter/material.dart';

void main() => runApp(NuevoGrupoApp());

class NuevoGrupoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuevo Grupo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A2A), // Fondo oscuro azulado
      ),
      home: NuevoGrupoScreen(),
    );
  }
}

class NuevoGrupoScreen extends StatelessWidget {
  final TextEditingController claseController = TextEditingController();
  final TextEditingController grupoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '¿Nuevo grupo? 👩‍🏫',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1B3A),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Crea un nuevo grupo',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Grupo',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.access_time, color: Colors.greenAccent),
                        SizedBox(width: 10),
                        Icon(Icons.calendar_today, color: Colors.greenAccent),
                      ],
                    ),
                    Divider(color: Colors.white54, thickness: 1),
                    SizedBox(height: 16),
                    TextField(
                      controller: claseController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Clase',
                        labelStyle: TextStyle(color: Colors.purpleAccent),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purpleAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: grupoController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Grupo',
                        labelStyle: TextStyle(color: Colors.purpleAccent),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purpleAccent),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            claseController.clear();
                            grupoController.clear();
                          },
                          child: Text('Cancelar', style: TextStyle(color: Colors.greenAccent)),
                        ),
                        SizedBox(width: 16),
                        TextButton(
                          onPressed: () {
                            // Acción para agregar
                            String clase = claseController.text;
                            String grupo = grupoController.text;
                            print('Clase: $clase, Grupo: $grupo');
                          },
                          child: Text('Agregar', style: TextStyle(color: Colors.greenAccent)),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}