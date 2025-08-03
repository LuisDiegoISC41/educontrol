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
    final parts = fullName.trim().split(RegExp(r'\s+'));
    String nombre = '';
    String apellidoPaterno = '';
    String apellidoMaterno = '';

    if (parts.length == 1) {
      nombre = parts[0];
    } else if (parts.length == 2) {
      nombre = parts[0];
      apellidoPaterno = parts[1];
    } else {
      nombre = parts.sublist(0, parts.length - 2).join(' ');
      apellidoPaterno = parts[parts.length - 2];
      apellidoMaterno = parts.last;
    }

    return DocenteModel(
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correo: email,
      password: 'google_auth',
    );
  }
}
