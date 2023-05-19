/// Represents an exception that occurred during an API call.
class CallApiException implements Exception {
  final String message;

  CallApiException(this.message);

  @override
  String toString() => 'CallApiException: $message';
}
