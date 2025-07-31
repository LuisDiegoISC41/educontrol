class DocenteModel {
  final int? idDocente;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correo;
  final String  password;

  DocenteModel({
    this.idDocente,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
    required this.password,
  });

  /// Construir desde Supabase
  factory DocenteModel.fromMap(Map<String, dynamic> map) {
    return DocenteModel(
      idDocente: map['id_docente'] as int?,
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
      if (idDocente != null) 'id_docente': idDocente,
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
