import 'package:flutter/material.dart';

class BienvenidaAlu extends StatelessWidget {
  const BienvenidaAlu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Text(
          'Bienvenido Alumno',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
