import 'package:supabase_flutter/supabase_flutter.dart';

class AsistenciaRemoteDataSource {
  final SupabaseClient client;
  AsistenciaRemoteDataSource(this.client);

  Future<List<Map<String, dynamic>>> fetchAlumnosPorGrupo(int idGrupo) async {
    final alumnosGrupo = await client
        .from('alumno_grupo')
        .select('id_alumno')
        .eq('id_grupo', idGrupo);

    final ids = alumnosGrupo.map((e) => e['id_alumno']).toList();
    if (ids.isEmpty) return [];

    final alumnos = await client
        .from('alumno')
        .select('id_alumno, nombre')
        .inFilter('id_alumno', ids);

    return List<Map<String, dynamic>>.from(alumnos);
  }

  Future<void> saveAsistencias(int idGrupo, List<Map<String, dynamic>> data) async {
    await client.from('asistencia').insert(data);
  }
}
