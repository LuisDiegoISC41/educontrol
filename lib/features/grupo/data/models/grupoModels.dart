class GrupoModel {
  final int? idGrupo;
  final String nombre;
  final String qr;
  final int idDocente;

  GrupoModel({
    this.idGrupo,
    required this.nombre,
    required this.qr,
    required this.idDocente,
  });

  factory GrupoModel.fromMap(Map<String, dynamic> map) {
    return GrupoModel(
      idGrupo: map['id_grupo'] as int?,
      nombre: map['nombre'] as String,
      qr: map['qr'] as String,
      idDocente: map['id_docente'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idGrupo != null) 'id_grupo': idGrupo,
      'nombre': nombre,
      'qr': qr,
      'id_docente': idDocente,
    };
  }
}