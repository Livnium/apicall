import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import '../callapi.dart';

/// Provides methods to perform HTTP requests to an API and handle responses.
///
/// The CallApi class is implemented as a singleton, meaning that only one instance
/// of the class can exist for a specific base URL. This is useful when you want to
/// make multiple API calls to the same base URL, as it allows you to reuse the same
/// CallApi instance.
class CallApi {
  /// The base URL of the API.
  final String baseUrl;

  /// A private constructor that initializes the base URL of the CallApi instance.
  ///
  /// This constructor is private to prevent direct instantiation of the CallApi class.
  /// Instead, the CallApi class should be instantiated through the factory constructor.
  CallApi._privateConstructor(this.baseUrl);

  /// A map that holds the instances of CallApi that have already been created.
  ///
  /// The keys are the base URLs and the values are the corresponding CallApi instances.
  static final Map<String, CallApi> _instances = <String, CallApi>{};

  /// A factory constructor that creates a new instance of CallApi or returns an existing one.
  ///
  /// If an instance of CallApi for the specified base URL already exists, this constructor
  /// returns that instance. Otherwise, it creates a new instance and adds it to the _instances map.
  factory CallApi({required String baseUrl}) {
    return _instances.putIfAbsent(
        baseUrl, () => CallApi._privateConstructor(baseUrl));
  }

  /// Performs an HTTP request to the API and returns the response.
  ///
  /// [path] specifies the path to append to the base URL.
  /// [method] specifies the HTTP method to use for the request.
  /// [body] is the request body, in the form of a map of key-value pairs.
  /// [headers] are the request headers, in the form of a map of key-value pairs.
  /// [queryParameters] are the query parameters to append to the URL, in the form of a map of key-value pairs.
  /// [jsonParser] is a function that takes a JSON string and returns an object of type T.
  /// If provided, this function will be used to parse the JSON response from the server.
  Future<T> request<T>({
    required String path,
    required HttpMethod method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
    T Function(String)? jsonParser,
  }) async {
    final String url = baseUrl + path + _encodeQueryParameters(queryParameters);

    http.Response response;
    try {
      switch (method) {
        case HttpMethod.get:
          response = await http.get(Uri.parse(url), headers: headers);
          break;
        case HttpMethod.post:
          response = await http.post(Uri.parse(url),
              headers: headers, body: json.encode(body));
          break;
        case HttpMethod.put:
          response = await http.put(Uri.parse(url),
              headers: headers, body: json.encode(body));
          break;
        case HttpMethod.patch:
          response = await http.patch(Uri.parse(url),
              headers: headers, body: json.encode(body));
          break;
        case HttpMethod.delete:
          response = await http.delete(Uri.parse(url), headers: headers);
          break;
      }
    } catch (e) {
      log('Error making API call: $e', name: 'CallApi');
      throw CallApiException('Error making API call: $e');
    }

    return _handleResponse<T>(response, jsonParser);
  }

  /// Handles the response from the API and returns the response as an object of type T.
  ///
  /// [response] is the response from the server.
  /// [jsonParser] is a function that takes a JSON string and returns an object of type T.
  /// If provided, this function will be used to parse the JSON response from the server.
  T _handleResponse<T>(http.Response response, T Function(String)? jsonParser) {
    log('API response: ${response.body}', name: 'CallApi');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonParser != null
          ? jsonParser(response.body)
          : response.body as T;
    } else {
      throw CallApiException(
          'Request failed with status code ${response.statusCode}');
    }
  }

  /// Encodes the query parameters into a string that can be appended to a URL.
  ///
  /// [parameters] are the query parameters to encode, in the form of a map of key-value pairs.
  /// If [parameters] is null, this method returns an empty string.
  ///
  /// The returned string starts with a question mark (?), followed by the encoded key-value pairs.
  /// Each key-value pair is separated by an equals sign (=), and the pairs are separated by ampersands (&).
  String _encodeQueryParameters(Map<String, String>? parameters) {
    if (parameters == null) {
      return '';
    }

    return '?${parameters.entries.map((entry) => '${Uri.encodeQueryComponent(entry.key)}=${Uri.encodeQueryComponent(entry.value)}').join('&')}';
  }
}
