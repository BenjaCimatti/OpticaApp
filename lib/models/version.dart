class Version {
    
    String version;
    
    Version({
        required this.version,
    });

    factory Version.fromJson(Map<String, dynamic> json) => Version(
        version: json["Version"],
    );
}
