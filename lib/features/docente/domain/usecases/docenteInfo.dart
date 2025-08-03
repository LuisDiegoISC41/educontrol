import '../repositories/docenteRepo.dart';

class GetGruposByDocente {
  final DocenteRepository repository;

  GetGruposByDocente(this.repository);

  Future<List<Map<String, dynamic>>> call(int idDocente) async {
    return await repository.getGruposByDocente(idDocente);
  }
}
