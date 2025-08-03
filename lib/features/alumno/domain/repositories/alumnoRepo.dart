import '../entities/alumno.dart';

abstract class AlumnoRepository {
  Future<Alumno?> getAlumnoByCorreo(String correo);
  Future<void> addAlumno(Alumno alumno);
}