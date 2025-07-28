class AlumnoModel {
  final int? idAlumno;
  final String matricula;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correo;
  final String contrasena;

  AlumnoModel({
    this.idAlumno,
    required this.matricula,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
    required this.contrasena,
  });

  /// Crear AlumnoModel desde un mapa (ej: obtenido de Supabase)
  factory AlumnoModel.fromMap(Map<String, dynamic> map) {
    return AlumnoModel(
      idAlumno: map['ID_Alumno'] as int?,
      matricula: map['Matricula'] ?? '',
      nombre: map['Nombre'] ?? '',
      apellidoPaterno: map['Apellido_Paterno'] ?? '',
      apellidoMaterno: map['Apellido_Materno'] ?? '',
      correo: map['Correo'] ?? '',
      contrasena: map['Contraseña'] ?? '',
    );
  }

  /// Convertir el modelo a un mapa (para insertar en Supabase)
  Map<String, dynamic> toMap() {
    return {
      if (idAlumno != null) 'ID_Alumno': idAlumno,
      'Matricula': matricula,
      'Nombre': nombre,
      'Apellido_Paterno': apellidoPaterno,
      'Apellido_Materno': apellidoMaterno,
      'Correo': correo,
      'Contraseña': contrasena,
    };
  }

  /// Crear AlumnoModel desde los datos de Google
  factory AlumnoModel.fromGoogle(String fullName, String email) {
    final parts = fullName.split(' ');
    return AlumnoModel(
      matricula: _generateMatricula(),
      nombre: parts.isNotEmpty ? parts.first : '',
      apellidoPaterno: parts.length > 1 ? parts[1] : '',
      apellidoMaterno: parts.length > 2 ? parts[2] : '',
      correo: email,
      contrasena: 'google_auth', // marcador porque no hay contraseña
    );
  }

  static String _generateMatricula() {
    final now = DateTime.now();
    return '${now.year % 100}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }
}
