import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:educontrol/features/alumno/data/models/alumnoModels.dart';

class AlumnoRemoteDataSource {
  final SupabaseClient supabase;
  AlumnoRemoteDataSource(this.supabase);

  /// Obtener datos de un alumno por correo
  Future<AlumnoModel?> getAlumnoByCorreo(String correo) async {
    final response = await supabase
        .from('alumno')
        .select()
        .eq('correo', correo)
        .maybeSingle();

    if (response != null) {
      return AlumnoModel.fromMap(response);
    }
    return null;
  }

  /// Insertar un nuevo alumno
  Future<void> insertAlumno(AlumnoModel alumno) async {
    await supabase.from('alumno').insert(alumno.toMap());
  }
}
