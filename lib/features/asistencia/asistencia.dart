import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AsistenciasScreen extends StatefulWidget {
  final String materia; // Nombre de la materia
  final int idAlumno;   // ID del alumno
  final int idGrupo;    // ID del grupo

  const AsistenciasScreen({
    super.key,
    required this.materia,
    required this.idAlumno,
    required this.idGrupo,
  });

  @override
  State<AsistenciasScreen> createState() => _AsistenciasScreenState();
}

class _AsistenciasScreenState extends State<AsistenciasScreen> {
  late Map<DateTime, Map<String, dynamic>> asistenciasMap; // Estado + fechaHora
  DateTime _fechaSeleccionada = DateTime.now();
  bool _cargando = true;

  // Auxiliar para ignorar horas, minutos y segundos en un DateTime
  DateTime _soloFecha(DateTime dt) => DateTime(dt.year, dt.month, dt.day);

  @override
  void initState() {
    super.initState();
    asistenciasMap = {};
    cargarAsistencias();
  }

  /// Consulta a la base de datos filtrando por alumno y grupo
  Future<void> cargarAsistencias() async {
    try {
      final supabase = Supabase.instance.client;

      final List<dynamic> response = await supabase
          .from('asistencia')
          .select('id_asistencia, estado, fecha, fecha_hora, id_alumno, id_sesion, sesion_clase(id_grupo)')
          .eq('id_alumno', widget.idAlumno)
          .order('fecha_hora', ascending: true);

      final filtradoPorGrupo = response.where((asistencia) {
        final sesion = asistencia['sesion_clase'];
        if (sesion == null) return false;
        return sesion['id_grupo'] == widget.idGrupo;
      }).toList();

      setState(() {
        asistenciasMap = {
          for (var asistencia in filtradoPorGrupo)
            _soloFecha(DateTime.parse(asistencia['fecha']).toLocal()): {
              'estado': asistencia['estado'],
              'fechaHora': DateTime.parse(asistencia['fecha_hora']).toLocal(),
            }
        };
        _cargando = false;
      });
    } catch (e) {
      print("Error al cargar asistencias: $e");
      setState(() {
        asistenciasMap = {};
        _cargando = false;
      });
    }
  }

  /// Define color según el estado
  Color _getColor(String? estado) {
    switch (estado) {
      case 'Asistencia':
        return Colors.greenAccent;
      case 'Retardo':
        return Colors.yellowAccent;
      case 'Falta':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  /// Muestra diálogo con hora de asistencia
  void _mostrarHoraAsistencia(DateTime fecha) {
    final asistencia = asistenciasMap[_soloFecha(fecha)];
    if (asistencia == null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sin asistencia'),
          content: Text('No hay registro de asistencia para el día ${fecha.day}/${fecha.month}/${fecha.year}.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
      return;
    }

    final hora = asistencia['fechaHora'] as DateTime;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hora de asistencia'),
        content: Text(
          'Estado: ${asistencia['estado']}\nHora registrada: '
          '${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF5FD89C);

    return Scaffold(
      backgroundColor: const Color(0xFF0B0C2A),
      body: SafeArea(
        child: _cargando
            ? const Center(
                child: CircularProgressIndicator(color: verde),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // alineado a la izquierda
                  children: [
                    const Text(
                      'Asistencias',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.materia, // materia a la izquierda
                      style: const TextStyle(
                        fontSize: 25,
                        color: verde,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: TableCalendar(
                        firstDay: DateTime.utc(2000, 1, 1),
                        lastDay: DateTime.utc(2100, 12, 31),
                        focusedDay: _fechaSeleccionada,
                        selectedDayPredicate: (day) =>
                            isSameDay(day, _fechaSeleccionada),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _fechaSeleccionada = selectedDay;
                          });
                          _mostrarHoraAsistencia(selectedDay);
                        },
                        headerStyle: const HeaderStyle(
                          titleTextStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          formatButtonVisible: false,
                          leftChevronIcon:
                              Icon(Icons.chevron_left, color: Colors.white),
                          rightChevronIcon:
                              Icon(Icons.chevron_right, color: Colors.white),
                          headerPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        calendarStyle: const CalendarStyle(
                          todayDecoration: BoxDecoration(
                            color: Colors.blueAccent,
                            shape: BoxShape.circle,
                          ),
                          outsideDaysVisible: false,
                        ),
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, date, _) {
                            final estado =
                                asistenciasMap[_soloFecha(date)]?['estado'];
                            return Container(
                              margin: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _getColor(estado),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '${date.day}',
                                style: const TextStyle(color: Colors.black),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _Legend(color: Colors.greenAccent, text: "Asistencia"),
                        _Legend(color: Colors.yellowAccent, text: "Retardo"),
                        _Legend(color: Colors.redAccent, text: "Falta"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: verde,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 12),
                        ),
                        child: const Text(
                          "Regresar",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;
  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 8, backgroundColor: color),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}