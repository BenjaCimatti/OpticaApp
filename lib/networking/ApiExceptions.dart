class ApiException implements Exception {
  final _message;
  final _prefix;
  final code;
  
  ApiException([
    this._message, this._prefix, this.code
  ]);

  String toString() {
    return "$code $_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message, code]) : super(message, "Error During Communication: ", code);
}

class BadRequestException extends ApiException {
  BadRequestException([message, code]) : super(message, "Invalid Request: ", code);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([message, code]) : super(message, "Unauthorized: ", code);
}

class InternalServerException extends ApiException {
  InternalServerException([message, code]) : super(message, "Internal Server Error: ", code);
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message, code]) : super(message, "Invalid Input: ", code);
}