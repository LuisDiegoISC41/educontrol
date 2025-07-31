class AlumnoModel {
  final int? idAlumno;
  final String? matricula;
  final String? nombre;
  final String? apellidoPaterno;
  final String? apellidoMaterno;
  final String correo;
  final String? password;

  AlumnoModel({
    this.idAlumno,
    this.matricula,
    this.nombre,
    this.apellidoPaterno,
    this.apellidoMaterno,
    required this.correo,
    this.password,
  });

  /// Crear AlumnoModel desde un mapa (ej: obtenido de Supabase)
  factory AlumnoModel.fromMap(Map<String, dynamic> map) {
    return AlumnoModel(
      idAlumno: map['id_alumno'] as int?,
      matricula: map['matricula'] ?? '',
      nombre: map['nombre'] ?? '',
      apellidoPaterno: map['apellido_paterno'] ?? '',
      apellidoMaterno: map['apellido_materno'] ?? '',
      correo: map['correo'] ?? '',
      password: map['password'] ?? '',
    );
  }

  /// Convertir el modelo a un mapa (para insertar en Supabase)
  Map<String, dynamic> toMap() {
    return {
      if (idAlumno != null) 'id_alumno': idAlumno,
      'matricula': matricula,
      'nombre': nombre,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'correo': correo,
      'password': password,
    };
  }

  /// Crear AlumnoModel desde los datos de Google
  factory AlumnoModel.fromGoogle(String fullName, String email) {
    final parts = fullName.split(' ');
    // Extrae los números al inicio del correo antes del @
    final match = RegExp(r'^(\d+)').firstMatch(email);
    final matricula = match != null ? match.group(1) : _generateMatricula();

    return AlumnoModel(
      matricula: matricula,
      nombre: parts.isNotEmpty ? parts.first : '',
      apellidoPaterno: parts.length > 1 ? parts[1] : '',
      apellidoMaterno: parts.length > 2 ? parts[2] : '',
      correo: email,
      password: 'google_auth', // marcador porque no hay contraseña
    );
  }

  static String _generateMatricula() {
    final now = DateTime.now();
    return '${now.year % 100}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }
}