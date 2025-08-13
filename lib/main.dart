import 'package:flutter/material.dart';
import 'core/database/appBD.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Se genera con "flutterfire configure"
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await appBD.init();

  // Verificamos si ya se guardó un tipo de usuario
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? tipoUsuario = prefs.getString('tipoUsuario');

  runApp(MyApp(tipoUsuario: tipoUsuario));
}

class MyApp extends StatelessWidget {
  final String? tipoUsuario;

  const MyApp({super.key, this.tipoUsuario});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: tipoUsuario == null
          ? const EduControlWelcome()
          : LoginPage(tipo: tipoUsuario!), // Ir directo al login si ya lo guardó
    );
  }
}

class EduControlWelcome extends StatefulWidget {
  const EduControlWelcome({super.key});

  @override
  State<EduControlWelcome> createState() => _EduControlWelcomeState();
}

class _EduControlWelcomeState extends State<EduControlWelcome> {
  String _tipoUsuario = "Alumno"; // Valor por defecto

  Future<void> _guardarYContinuar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tipoUsuario', _tipoUsuario);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(tipo: _tipoUsuario),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              // Icono y nombre (encabezado)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFF23B17D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contenido principal con Expanded
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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

                    // Selector de tipo de usuario
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButton<String>(
                        value: _tipoUsuario,
                        dropdownColor: Colors.white,
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        style: const TextStyle(
                            color: Colors.black, fontSize: 16),
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
                        onPressed: _guardarYContinuar,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
