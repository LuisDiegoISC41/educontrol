import 'package:flutter/material.dart';
import 'login.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: EduControlWelcome(),
  ));
}

class EduControlWelcome extends StatefulWidget {
  const EduControlWelcome({super.key});

  @override
  
  State<EduControlWelcome> createState() => _EduControlWelcomeState();
}

class _EduControlWelcomeState extends State<EduControlWelcome> {
  String _tipoUsuario = "Alumno"; // Valor por defecto

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B0147),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icono y nombre
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
                      const SizedBox(width: 10),
                      const Text(
                        'EduControl',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      // Acción al cerrar
                    },
                  )
                ],
              ),

              const Spacer(),

              // Texto principal
              const Text(
                'Simplifica el pase de lista en tus clases.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Registra asistencia de forma\nrápida y segura.\nGenera un código QR único\npor clase y horario.\nLos alumnos solo escanean y listo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              // Selector de tipo de usuario
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<String>(
                  value: _tipoUsuario,
                  dropdownColor: Colors.white,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  underline: const SizedBox(),
                  onChanged: (String? value) {
                    setState(() {
                      _tipoUsuario = value!;
                    });
                  },
                  items: <String>['Alumno', 'Docente']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Botón Registrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context)=> LoginPage(tipo: _tipoUsuario))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FFAA),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Registrar',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Botón Iniciar sesión
              TextButton(
                onPressed: () {
                  // Ir a login
                },
                child: const Text(
                  'Iniciar sesión',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
