import '../../domain/repositories/docenteRepo.dart';
import '../datasources/docenteData.dart';

class DocenteRepositoryImpl implements DocenteRepository {
  final DocenteRemoteDataSource remoteDataSource;

  DocenteRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Map<String, dynamic>>> getGruposByDocente(int idDocente) async {
    return await remoteDataSource.fetchGrupos(idDocente);
  }
}
