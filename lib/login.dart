import 'package:flutter/material.dart';
import 'package:educontrol/alumno/bienvenidaAlum.dart';
import 'package:educontrol/docente/bienvenidaDoc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login UI',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(tipo: 'alumno'), // Cambiar a 'docente' para probar
    );
  }
}

class LoginPage extends StatefulWidget {
  final String tipo;
  const LoginPage({super.key, required this.tipo});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _tipoUsuario;

  @override
  void initState() {
    super.initState();
    _tipoUsuario = widget.tipo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E2A),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.purpleAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),

                      // Usuario
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '@gmail.com',
                          hintStyle: const TextStyle(color: Colors.purpleAccent),
                          labelText: 'Usuario',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Contraseña
                      TextField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'pas123\$',
                          hintStyle: const TextStyle(color: Colors.purpleAccent),
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.purpleAccent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Google Sign In
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        icon: Image.network(
                          'https://img.icons8.com/color/48/000000/google-logo.png',
                          width: 24,
                          height: 24,
                        ),
                        label: const Text("Sign in with Google"),
                      ),
                      const SizedBox(height: 20),

                      // Register Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FFAA),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          // Redirigir según el tipo de usuario
                          if (_tipoUsuario.toLowerCase() == 'alumno') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const BienvenidaAlu()),
                            );
                          } else if (_tipoUsuario.toLowerCase() == 'docente') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const WelcomePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tipo de usuario desconocido: $_tipoUsuario')),
                            );
                          }
                        },
                        child: const Text("Register"),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
