class GrupoModel {
  final int? idGrupo;
  final String nombre;
  final String grupo;
  final int idDocente;
  final String qrGrupo;

  GrupoModel({
    this.idGrupo,
    required this.nombre,
    required this.grupo,
    required this.idDocente,
    required this.qrGrupo
  });

  factory GrupoModel.fromMap(Map<String, dynamic> map) {
    return GrupoModel(
      idGrupo: map['id_grupo'] as int?,
      nombre: map['nombre'] as String,
      grupo: map['grupo'] as String,
      idDocente: map['id_docente'] as int,
      qrGrupo: map['qr_grupo']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (idGrupo != null) 'id_grupo': idGrupo,
      'nombre': nombre,
      'grupo': grupo,
      'id_docente': idDocente,
      'qr_grupo': qrGrupo,
    };
  }
}
