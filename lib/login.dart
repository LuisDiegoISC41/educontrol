import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:educontrol/core/services/servicioGoogle.dart';
import 'package:educontrol/features/alumno/presentation/pages/bienvenidaAlum.dart';
import 'package:educontrol/features/docente/presentation/pages/bienvenidaDoc.dart';

class LoginPage extends StatefulWidget {
  final String tipo;
  const LoginPage({super.key, required this.tipo});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String _tipoUsuario;
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoUsuario = widget.tipo;
  }

  Future<String?> _pedirNuevaPassword(BuildContext context) async {
    String nuevaPassword = '';
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Establece una contraseña'),
          content: TextField(
            autofocus: true,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            onChanged: (value) => nuevaPassword = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(nuevaPassword),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
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
                        controller: _correoController,
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
                        controller: _passwordController,
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
                            await GoogleSignIn().signOut();
                            final user = await authService.signInWithGoogle(_tipoUsuario);
                            if (user != null) {
                              final client = GoogleAuthService().client;

                              final alumno = await client
                                  .from('alumno')
                                  .select()
                                  .eq('correo', user.email ?? '')
                                  .maybeSingle();

                              final docente = await client
                                  .from('docente')
                                  .select()
                                  .eq('correo', user.email ?? '')
                                  .maybeSingle();

                              if (alumno != null && (alumno['password'] == 'google_auth' || alumno['password'] == null)) {
                                final nuevaPassword = await _pedirNuevaPassword(context);
                                if (nuevaPassword != null && nuevaPassword.isNotEmpty) {
                                  await client
                                      .from('alumno')
                                      .update({'password': nuevaPassword})
                                      .eq('correo', user.email ?? '');
                                }
                              }

                              if (docente != null && (docente['password'] == 'google_auth' || docente['password'] == null)) {
                                final nuevaPassword = await _pedirNuevaPassword(context);
                                if (nuevaPassword != null && nuevaPassword.isNotEmpty) {
                                  await client
                                      .from('docente')
                                      .update({'password': nuevaPassword})
                                      .eq('correo', user.email ?? '');
                                }
                              }

                              if (_tipoUsuario.toLowerCase() == 'alumno' && alumno != null) {
                                final nombreCompleto = '${alumno['nombre']}}';
                                final matricula = alumno['matricula'] ?? '';

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BienvenidaAlu(
                                      nombreCompleto: nombreCompleto,
                                      matricula: matricula,
                                    ),
                                  ),
                                );
                              } else if (_tipoUsuario.toLowerCase() == 'docente' && docente != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WelcomePage(idDocente: docente['id_docente']),
                                  ),
                                );
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
                        onPressed: () async {
                          final correo = _correoController.text.trim();
                          final password = _passwordController.text.trim();

                          if (correo.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Por favor ingresa correo y contraseña')),
                            );
                            return;
                          }

                          final client = GoogleAuthService().client;

                          final alumno = await client
                              .from('alumno')
                              .select()
                              .eq('correo', correo)
                              .maybeSingle();

                          if (alumno != null) {
                            if (alumno['password'] == 'google_auth' || alumno['password'] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Este usuario solo puede iniciar sesión con Google o debe establecer una contraseña.')),
                              );
                              return;
                            }
                            if (alumno['password'] == password) {
                              final nombreCompleto = '${alumno['nombre']}';
                              final matricula = alumno['matricula'] ?? '';

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BienvenidaAlu(
                                    nombreCompleto: nombreCompleto,
                                    matricula: matricula,
                                  ),
                                ),
                              );
                              return;
                            }
                          }

                          final docente = await client
                              .from('docente')
                              .select()
                              .eq('correo', correo)
                              .maybeSingle();

                          if (docente != null) {
                            if (docente['password'] == 'google_auth' || docente['password'] == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Este usuario solo puede iniciar sesión con Google o debe establecer una contraseña.')),
                              );
                              return;
                            }
                            if (docente['password'] == password) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomePage(idDocente: docente['id_docente']),
                                ),
                              );
                              return;
                            }
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Usuario o contraseña incorrectos')),
                          );
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
