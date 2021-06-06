class Token {
    
    String token;
    
    Token({
        required this.token,
    });

    factory Token.fromJson(Map<String, dynamic> json) => Token(
        token: json["data"],
    );
}
