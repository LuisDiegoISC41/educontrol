import 'package:flutter/material.dart';
import 'package:educontrol/core/services/servicioGoogle.dart';
import 'package:educontrol/features/alumno/bienvenidaAlum.dart';
import 'package:educontrol/features/docente/bienvenidaDoc.dart';

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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                const Text(
                  'EduControl',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1B3A),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'usuario@gmail.com',
                          hintStyle: const TextStyle(color: Colors.white54),
                          labelText: 'Correo',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.email, color: Colors.purpleAccent),
                          filled: true,
                          fillColor: const Color(0xFF2D2D4A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: '********',
                          hintStyle: const TextStyle(color: Colors.white54),
                          labelText: 'Contraseña',
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(Icons.lock, color: Colors.purpleAccent),
                          filled: true,
                          fillColor: const Color(0xFF2D2D4A),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final authService = GoogleAuthService();
                          try {
                            final user = await authService.signInWithGoogle(_tipoUsuario);
                            if (user != null) {
                              if (_tipoUsuario.toLowerCase() == 'alumno') {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BienvenidaAlu()));
                              } else {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomePage()));
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error al iniciar sesión: $e')),
                            );
                          }
                        },
                        icon: Image.network(
                          'https://img.icons8.com/color/48/000000/google-logo.png',
                          width: 24,
                          height: 24,
                        ),
                        label: const Text("Continuar con Google"),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00FFAA),
                          foregroundColor: Colors.black,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          if (_tipoUsuario.toLowerCase() == 'alumno') {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BienvenidaAlu()));
                          } else if (_tipoUsuario.toLowerCase() == 'docente') {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomePage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tipo de usuario desconocido: $_tipoUsuario')),
                            );
                          }
                        },
                        child: const Text("Iniciar sesión"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
