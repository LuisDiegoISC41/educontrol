import '../../domain/entities/docente.dart';

class DocenteModel extends Docente {
  final String password;

  DocenteModel({
    int? id,
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String correo,
    required this.password,
  }) : super(
          id: id,
          nombre: nombre,
          apellidoPaterno: apellidoPaterno,
          apellidoMaterno: apellidoMaterno,
          correo: correo,
        );

  /// Construir desde Supabase
  factory DocenteModel.fromMap(Map<String, dynamic> map) {
    return DocenteModel(
      id: map['id_docente'] as int?,
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'] ?? '',
      correo: map['correo'] ?? '',
      password: map['contraseña'] ?? '',
    );
  }

  /// Convertir a Map (para guardar en Supabase)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id_docente': id,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'correo': correo,
      'password': password,
    };
  }

  /// Crear desde datos de Google
  factory DocenteModel.fromGoogle(String fullName, String email) {
    final parts = fullName.split(' ');
    return DocenteModel(
      nombre: parts.isNotEmpty ? parts.first : '',
      apellidoPaterno: parts.length > 1 ? parts[1] : '',
      apellidoMaterno: parts.length > 2 ? parts[2] : '',
      correo: email,
      password: 'google_auth',
    );
  }
}
