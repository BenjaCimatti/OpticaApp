class ReturningEnvio {

    ReturningEnvio({
      required this.idCliente,
      required this.geoLatitud,
      required this.geoLongitud,
    });

    int idCliente;
    double geoLatitud;
    double geoLongitud;

    Map<String, dynamic> toJson() => {
        "IdCliente": idCliente,
        "GeoLatitud": geoLatitud,
        "GeoLongitud": geoLongitud,
    };
}
