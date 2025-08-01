import '../entities/asistencia.dart';

abstract class AsistenciaRepository {
  Future<List<Alumno>> obtenerAlumnosPorGrupo(int idGrupo);
  Future<void> guardarAsistencias(int idGrupo, List<Alumno> alumnos);
}
