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
    final parts = fullName.trim().split(RegExp(r'\s+')); // divide por cualquier cantidad de espacios
    String nombre = '';
    String apellidoPaterno = '';
    String apellidoMaterno = '';

    if (parts.length == 1) {
      // Solo un nombre
      nombre = parts[0];
    } else if (parts.length == 2) {
      // Nombre y apellido
      nombre = parts[0];
      apellidoPaterno = parts[1];
    } else {
      // Dos nombres o más: junta todo menos los 2 últimos como "nombre"
      nombre = parts.sublist(0, parts.length - 2).join(' ');
      apellidoPaterno = parts[parts.length - 2];
      apellidoMaterno = parts.last;
    }

    // Extrae matrícula del correo si empieza con números
    final match = RegExp(r'^(\d+)').firstMatch(email);
    final matricula = match != null ? match.group(1) : _generateMatricula();

    return AlumnoModel(
      matricula: matricula,
      nombre: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correo: email,
      password: 'google_auth',
    );
  }

  static String _generateMatricula() {
    final now = DateTime.now();
    return '${now.year % 100}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
  }
}