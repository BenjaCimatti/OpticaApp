class Client {
    Client({
        required this.idCliente,
        required this.descCliente,
        required this.idTransportista,
    });

    int idCliente;
    String descCliente;
    int idTransportista;

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        idCliente: json["IdCliente"],
        descCliente: json["DescCliente"],
        idTransportista: json["IdTransportista"],
    );
}
