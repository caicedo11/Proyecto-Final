class Usuario {
  final int? id;
  final String? nombre;
  final String? apellido;
  final String? usuario;
  final int? idCargo;

  Usuario({this.id, this.nombre, this.apellido, this.usuario, this.idCargo});

  // Mapea los campos exactos que vimos en tu respuesta de Postman
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      usuario: json['usuario'],
      idCargo: json['idCargo'],
    );
  }
}