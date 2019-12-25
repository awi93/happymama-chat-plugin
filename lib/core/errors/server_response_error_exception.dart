class ServerResponseErrorException implements Exception {

  final int _statusCode;
  final String _message;
  final Map<String, dynamic> _errors;

  ServerResponseErrorException(this._statusCode, this._message, this._errors);

  Map<String, dynamic> get errors => _errors;

  String get message => _message;

  int get statusCode => _statusCode;

}