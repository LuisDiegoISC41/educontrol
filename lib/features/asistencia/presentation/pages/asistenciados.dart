import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AttendanceScreen extends StatefulWidget {
  final String grupo; // Para identificar el grupo (opcional)
  const AttendanceScreen({super.key, required this.grupo});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  List<bool> attendance = List.generate(10, (index) => true);
  Future<void> generarQRTemporal() async {
    final supabase = Supabase.instance.client;

    try {
      // 1. Obtener id_grupo por nombre del grupo
      final grupoRes = await supabase
          .from('grupo')
          .select('id_grupo')
          .eq('nombre', widget.grupo)
          .maybeSingle();

      if (grupoRes == null) {
        throw 'Grupo no encontrado';
      }

      final idGrupo = grupoRes['id_grupo'];

      // 2. Crear qr_token único
      final now = DateTime.now().toUtc();
      final qrToken = '${idGrupo}_${now.millisecondsSinceEpoch}';

      // 3. Insertar en tabla sesionclase
      await supabase.from('sesionclase').insert({
        'id_grupo': idGrupo,
        'fecha_hora': now.toIso8601String(),
        'qr_token': qrToken,
        'creada_por': 'docente',
      });

      // 4. Mostrar QR en un Dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Código QR'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: qrToken,
                version: QrVersions.auto,
                size: 200.0,
              ),
              const SizedBox(height: 10),
              const Text('Válido por 10 minutos'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR generado por 10 minutos')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al generar QR: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C2A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0C2A),
        title: Text('Asistencias - ${widget.grupo}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.greenAccent),
            tooltip: 'Genear Qr',
            onPressed: () async {
              await generarQRTemporal();
            },
          )
        ],
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
