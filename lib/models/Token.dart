class Token {
    
  String token;
  String? usuario;
  int? idTransportista;
  int? idCliente;
  int? idRol;
  String? ultimoLogin;
  int? idOrganizacion;
  String? descUsuario;
  
  Token({
    required this.token,
    this.usuario,
    this.idTransportista,
    this.idCliente,
    this.idRol,
    this.ultimoLogin,
    this.idOrganizacion,
    this.descUsuario,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    token: json["data"],
    usuario: json["Usuario"],
    idTransportista: json["IdTransportista"],
    idCliente: json["idCliente"],
    idRol: json["IdRol"],
    ultimoLogin: json["UltimoLogin"],
    idOrganizacion: json["IdOrganizacion"],
    descUsuario: json["DescUsuario"]
  );
}
