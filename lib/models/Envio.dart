import 'package:laboratorio_elena/classes/FormatDate.dart';

class Envio {
  int idEnvio;
  int idCliente;
  String descCliente;
  int idTransportista;
  String descTransportista;
  String fechaCarga;
  String fechaEnvio;
  int idEstado;
  String descEstado;
  dynamic? geoLatitud;
  dynamic? geoLongitud;
  String observaciones;

  Envio({
      required this.idEnvio,
      required this.idCliente,
      required this.descCliente,
      required this.idTransportista,
      required this.descTransportista,
      required this.fechaCarga,
      required this.fechaEnvio,
      required this.idEstado,
      required this.descEstado,
      this.geoLatitud,
      this.geoLongitud,
      required this.observaciones,
  });



  factory Envio.fromJson(Map<String, dynamic> json) => Envio(
      idEnvio: json["IdEnvio"],
      idCliente: json["IdCliente"],
      descCliente: json["DescCliente"],
      idTransportista: json["IdTransportista"],
      descTransportista: json["DescTransportista"],
      fechaCarga: formatDate((json["FechaCarga"])),
      fechaEnvio: formatDate((json["FechaEnvio"])),
      idEstado: json["IdEstado"],
      descEstado: json["DescEstado"],
      geoLatitud: json["GeoLatitud"],
      geoLongitud: json["GeoLongitud"],
      observaciones: json["Observaciones"],
  );
}
