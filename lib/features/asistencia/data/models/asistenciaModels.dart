import '../../domain/entities/asistencia.dart';

class AlumnoModel extends Alumno {
  AlumnoModel({required super.id, required super.nombre, super.presente});

  factory AlumnoModel.fromMap(Map<String, dynamic> map) {
    return AlumnoModel(
      id: map['id_alumno'],
      nombre: map['nombre'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_alumno': id,
      'nombre': nombre,
      'presente': presente,
    };
  }
}
