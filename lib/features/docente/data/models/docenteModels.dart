class DocenteModel {
  final int? idDocente;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correo;
  final String contrasena;

  DocenteModel({
    this.idDocente,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
    required this.contrasena,
  });

  /// Construir desde Supabase
  factory DocenteModel.fromMap(Map<String, dynamic> map) {
    return DocenteModel(
      idDocente: map['ID_Docente'] as int?,
      nombre: map['Nombre'] ?? '',
      apellidoPaterno: map['Apellido_Paterno'] ?? '',
      apellidoMaterno: map['Apellido_Materno'] ?? '',
      correo: map['Correo'] ?? '',
      contrasena: map['Contraseña'] ?? '',
    );
  }

  /// Convertir a Map (para guardar en Supabase)
  Map<String, dynamic> toMap() {
    return {
      if (idDocente != null) 'ID_Docente': idDocente,
      'Nombre': nombre,
      'Apellido_Paterno': apellidoPaterno,
      'Apellido_Materno': apellidoMaterno,
      'Correo': correo,
      'Contraseña': contrasena,
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
      contrasena: 'google_auth',
    );
  }
}
