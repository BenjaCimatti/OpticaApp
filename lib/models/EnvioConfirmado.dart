class EnvioConfirmado {
  int idEnvio;
  double geoLatitud;
  double geoLongitud;

  EnvioConfirmado({
    required this.idEnvio,
    required this.geoLatitud,
    required this.geoLongitud,
  });

  Map<String, dynamic> toJson() => {
      "IdEnvio": idEnvio,
      "GeoLatitud": geoLatitud,
      "GeoLongitud": geoLongitud
  };

}