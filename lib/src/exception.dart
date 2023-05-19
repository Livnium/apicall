/// Represents an exception that occurred during an API call.
class ApiCallException implements Exception {
  final String message;

  ApiCallException(this.message);

  @override
  String toString() => 'ApiCallException: $message';
}
