class Token {
    
  String token;
  String usuario;
  int? idTransportista;
  int? idCliente;
  int idRol;
  String ultimoLogin;
  int idOrganizacion;
  
  Token({
    required this.token,
    required this.usuario,
    this.idTransportista,
    this.idCliente,
    required this.idRol,
    required this.ultimoLogin,
    required this.idOrganizacion,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    token: json["data"],
    usuario: json["Usuario"],
    idTransportista: json["IdTransportista"],
    idCliente: json["idCliente"],
    idRol: json["IdRol"],
    ultimoLogin: json["UltimoLogin"],
    idOrganizacion: json["IdOrganizacion"],
  );
}
