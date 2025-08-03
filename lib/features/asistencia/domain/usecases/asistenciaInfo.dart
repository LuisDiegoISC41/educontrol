import '../entities/asistencia.dart';
import '../repositories/asistenciaRepo.dart';

class GuardarAsistencias {
  final AsistenciaRepository repository;
  GuardarAsistencias(this.repository);

  Future<void> call(int idGrupo, List<Alumno> alumnos) async {
    await repository.guardarAsistencias(idGrupo, alumnos);
  }
}
