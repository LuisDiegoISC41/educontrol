import '../entities/asistencia.dart';
import '../repositories/asistenciaRepo.dart';

class ObtenerAlumnosPorGrupo {
  final AsistenciaRepository repository;
  ObtenerAlumnosPorGrupo(this.repository);

  Future<List<Alumno>> call(int idGrupo) async {
    return await repository.obtenerAlumnosPorGrupo(idGrupo);
  }
}
