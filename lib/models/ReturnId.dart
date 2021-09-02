class ReturnId {
    ReturnId({
        required this.idRetorno,
    });

    int idRetorno;

    factory ReturnId.fromJson(Map<String, dynamic> json) => ReturnId(
        idRetorno: json["idRetorno"],
    );
}
