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
      matricula: (map['matricula'] != null && map['matricula'].toString().isNotEmpty)
          ? map['matricula'].toString()
          : null,
      nombre: (map['nombre'] != null && map['nombre'].toString().isNotEmpty)
          ? map['nombre'].toString()
          : null,
      apellidoPaterno: (map['apellido_paterno'] != null && map['apellido_paterno'].toString().isNotEmpty)
          ? map['apellido_paterno'].toString()
          : null,
      apellidoMaterno: (map['apellido_materno'] != null && map['apellido_materno'].toString().isNotEmpty)
          ? map['apellido_materno'].toString()
          : null,
      correo: map['correo'] ?? '',
      password: (map['password'] != null && map['password'].toString().isNotEmpty)
          ? map['password'].toString()
          : null,
    );
  }

  /// Convertir el modelo a un mapa (para insertar en Supabase)
  Map<String, dynamic> toMap() {
    return {
      if (idAlumno != null) 'id_alumno': idAlumno,
      if (matricula != null) 'matricula': matricula,
      if (nombre != null) 'nombre': nombre,
      if (apellidoPaterno != null) 'apellido_paterno': apellidoPaterno,
      if (apellidoMaterno != null) 'apellido_materno': apellidoMaterno,
      'correo': correo,
      if (password != null) 'password': password,
    };
  }

  /// Crear AlumnoModel desde los datos de Google
  factory AlumnoModel.fromGoogle(String fullName, String email) {
    final parts = fullName.trim().split(RegExp(r'\s+'));

    String nombre = '';
    String apellidoPaterno = '';
    String apellidoMaterno = '';

    if (parts.isEmpty) {
      nombre = '';
    } else if (parts.length == 1) {
      nombre = parts[0];
    } else if (parts.length == 2) {
      nombre = parts[0];
      apellidoPaterno = parts[1];
    } else if (parts.length == 3) {
      nombre = parts[0];
      apellidoPaterno = parts[1];
      apellidoMaterno = parts[2];
    } else {
      // Ej: "Juan Carlos Pérez López" → nombre: "Juan Carlos", apellidos: "Pérez López"
      nombre = parts.sublist(0, parts.length - 2).join(' ');
      apellidoPaterno = parts[parts.length - 2];
      apellidoMaterno = parts.last;
    }

    // Extrae matrícula del correo si empieza con números
    final match = RegExp(r'^(\d+)').firstMatch(email);
    String matricula;
    if (match != null && match.group(1)!.isNotEmpty) {
      matricula = match.group(1)!;
    } else {
      matricula = _generateMatricula();
    }

    // Evitar matrícula vacía o nula
    if (matricula.trim().isEmpty || matricula == '0000000') {
      matricula = _generateMatricula();
    }

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
    // Formato: AAMMDD + 3 dígitos aleatorios
    final randomPart = (100 + (now.microsecond % 900)).toString();
    return '${now.year % 100}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}$randomPart';
  }
}
