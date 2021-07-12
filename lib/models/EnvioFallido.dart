class EnvioFallido {
  int idEnvio;
  double geoLatitud;
  double geoLongitud;
  String observaciones;

  EnvioFallido({
    required this.idEnvio,
    required this.geoLatitud,
    required this.geoLongitud,
    required this.observaciones,
  });

  Map<String, dynamic> toJson() => {
      "IdEnvio": idEnvio,
      "GeoLatitud": geoLatitud,
      "GeoLongitud": geoLongitud,
      "Observaciones": observaciones
  };

}