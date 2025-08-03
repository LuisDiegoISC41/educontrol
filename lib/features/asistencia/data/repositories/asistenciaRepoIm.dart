import '../../domain/entities/asistencia.dart';
import '../../domain/repositories/asistenciaRepo.dart';
import '../datasources/asistenciaData.dart';
import '../models/asistenciaModels.dart';

class AsistenciaRepositoryImpl implements AsistenciaRepository {
  final AsistenciaRemoteDataSource dataSource;
  AsistenciaRepositoryImpl(this.dataSource);

  @override
  Future<List<Alumno>> obtenerAlumnosPorGrupo(int idGrupo) async {
    final result = await dataSource.fetchAlumnosPorGrupo(idGrupo);
    return result.map((e) => AlumnoModel.fromMap(e)).toList();
  }

  @override
  Future<void> guardarAsistencias(int idGrupo, List<Alumno> alumnos) async {
    final data = alumnos.map((a) => {
          'id_grupo': idGrupo,
          'id_alumno': a.id,
          'estado': a.presente ? 'Asistencia' : 'Falta',
          'fecha': DateTime.now().toIso8601String(),
        }).toList();

    await dataSource.saveAsistencias(idGrupo, data);
  }
}
