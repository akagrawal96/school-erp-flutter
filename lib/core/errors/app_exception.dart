/// Errors raised by the data layer. Repositories translate them into
/// feature-specific failures; widgets never catch these directly.
sealed class AppException implements Exception {
  const AppException([this.message]);

  /// Server-provided or diagnostic message. Not shown to users as-is.
  final String? message;

  @override
  String toString() => '$runtimeType(${message ?? ''})';
}

/// No connection, DNS failure or timeout.
final class NetworkException extends AppException {
  const NetworkException([super.message]);
}

/// The session token is missing, expired or rejected (HTTP 401).
final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message]);
}

/// The server answered with an error status or `"status": false`.
final class ServerException extends AppException {
  const ServerException({String? message, this.statusCode}) : super(message);

  final int? statusCode;
}

/// The response did not have the expected shape.
final class ParsingException extends AppException {
  const ParsingException([super.message]);
}
