abstract class DocenteRepository {
  Future<List<Map<String, dynamic>>> getGruposByDocente(int idDocente);
}
