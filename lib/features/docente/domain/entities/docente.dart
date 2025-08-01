class Docente {
  final int? id;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correo;

  Docente({
    this.id,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correo,
  });
}
