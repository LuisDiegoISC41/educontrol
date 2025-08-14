import 'package:educontrol/core/database/appBD.dart';

class DocenteRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchGrupos(int idDocente) async {
    final data = await appBD.client
        .from('grupo')
        .select()
        .eq('id_docente', idDocente)
        .order('id_grupo', ascending: false);
    return (data as List).cast<Map<String, dynamic>>();
  }
}
