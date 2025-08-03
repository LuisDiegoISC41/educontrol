import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AsistenciasScreen extends StatefulWidget {
  final String materia;
  const AsistenciasScreen({super.key, required this.materia});

  @override
  State<AsistenciasScreen> createState() => _AsistenciasScreenState();
}

class _AsistenciasScreenState extends State<AsistenciasScreen> {
  late Map<DateTime, String> estados; // Estado de cada fecha

  @override
  void initState() {
    super.initState();
    estados = {
      DateTime(2025, 7, 17): 'Asistencia',
      DateTime(2025, 7, 18): 'Retardo',
      DateTime(2025, 7, 21): 'Falta',
      DateTime(2025, 7, 22): 'Asistencia',
      DateTime(2025, 7, 23): 'Retardo',
      DateTime(2025, 7, 24): 'Falta',
      DateTime(2025, 7, 25): 'Asistencia',
    };
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0C2A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Asistencias',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.materia,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C3A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2025, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: DateTime.now(),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, date, _) {
                        final estado = estados[DateTime(date.year, date.month, date.day)];
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
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text("Regresar"),
                ),
              )
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
