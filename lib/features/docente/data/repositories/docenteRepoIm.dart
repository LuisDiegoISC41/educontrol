import 'package:educontrol/core/database/appBD.dart';
import '../../domain/repositories/docenteRepo.dart';
import '../datasources/docenteData.dart';

class DocenteRepositoryImpl implements DocenteRepository {
  final DocenteRemoteDataSource remoteDataSource;

  DocenteRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Map<String, dynamic>>> getGruposByDocente(int idDocente) async {
    return await remoteDataSource.fetchGrupos(idDocente);
  }

  Future<bool> _existeGrupo(int idGrupo) async {
    final grupos = await appBD.client
        .from('grupo')
        .select()
        .eq('id_grupo', idGrupo);

    return grupos != null && (grupos as List).isNotEmpty;
  }

 
  Future<String> eliminarGrupo(int idGrupo) async {
    print('Intentando eliminar grupo con id: $idGrupo'); 

    // Verifica existencia
    final grupos = await appBD.client
        .from('grupo')
        .select()
        .eq('id_grupo', idGrupo);

    print('Respuesta al verificar existencia: $grupos'); 

    if (grupos == null || (grupos is List && grupos.isEmpty)) {
      return 'El grupo con id $idGrupo no existe.';
    }
    final response = await appBD.client
        .from('grupo')
        .delete()
        .eq('id_grupo', idGrupo)
        .order('idGrupo', ascending: false);


    print('Respuesta al eliminar: $response');  

    if (response == null || (response is List && response.isEmpty)) {
      return 'No se eliminó ningún grupo con id $idGrupo';
    }

    return 'Grupo eliminado correctamente.';
  }

}
