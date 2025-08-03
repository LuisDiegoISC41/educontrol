import '../entities/alumno.dart';
import '../repositories/alumnoRepo.dart';

class GetAlumnoInfo {
  final AlumnoRepository repository;
  GetAlumnoInfo(this.repository);

  Future<Alumno?> call(String correo) async {
    return await repository.getAlumnoByCorreo(correo);
  }
}
