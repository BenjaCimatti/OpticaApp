class Envio {
  int idEnvio;
  int idCliente;
  String descCliente;
  int idTransportista;
  String descTransportista;
  DateTime fechaCarga;
  dynamic? fechaEnvio;
  int idEstado;
  String descEstado;
  dynamic? geoLatitud;
  dynamic? geoLongitud;

  Envio({
      required this.idEnvio,
      required this.idCliente,
      required this.descCliente,
      required this.idTransportista,
      required this.descTransportista,
      required this.fechaCarga,
      this.fechaEnvio,
      required this.idEstado,
      required this.descEstado,
      this.geoLatitud,
      this.geoLongitud,
  });

  factory Envio.fromJson(Map<String, dynamic> json) => Envio(
      idEnvio: json["IdEnvio"],
      idCliente: json["IdCliente"],
      descCliente: json["DescCliente"],
      idTransportista: json["IdTransportista"],
      descTransportista: json["DescTransportista"],
      fechaCarga: DateTime.parse(json["FechaCarga"]),
      fechaEnvio: json["FechaEnvio"],
      idEstado: json["IdEstado"],
      descEstado: json["DescEstado"],
      geoLatitud: json["GeoLatitud"],
      geoLongitud: json["GeoLongitud"],
  );
}
