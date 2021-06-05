class ApiException implements Exception {
  final _message;
  final _prefix;
  
  ApiException([
    this._message, this._prefix
  ]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends ApiException {
  FetchDataException([String? message]) : super(message, "Error During Communication: ");
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([message]) : super(message, "Unauthorized: ");
}

class InternalServerException extends ApiException {
  InternalServerException([message]) : super(message, "Internal Server Error: ");
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}