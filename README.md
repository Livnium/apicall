
# Dart Call API

A Dart package for making HTTP requests to an API and handling the responses. It supports GET, POST, PUT, PATCH, and DELETE methods.

## Features

- Supports GET, POST, PUT, PATCH, and DELETE HTTP methods.
- Provides a method to parse the JSON response from the server into a custom data type.
- Includes error handling functionality, throwing an `CallApiException` whenever an error occurs during an API call.
- Implemented as a singleton to ensure only one instance exists for each base URL, allowing for efficient reuse of the instances across the application.

## Getting Started

First, add the `callapi` package to your pubspec dependencies.

To import `callapi`, add the following line to your Dart code:

```dart
import 'package:callapi/callapi.dart';
```

## Usage

Here's a simple example of how to use the `callapi` package:

```dart
void main() async {
  // Create an CallApi instance for a specific base URL
  CallApi api = CallApi(baseUrl: 'https://jsonplaceholder.typicode.com/');

  // Define a function to parse a JSON string into a Map
  Map<String, dynamic> jsonParser(String jsonString) {
    return jsonDecode(jsonString);
  }

  // Make a GET request
  Map<String, dynamic> getResponse = await api.request(
    path: 'posts/1',
    method: HttpMethod.get,
    jsonParser: jsonParser,
  );

  print('GET response: $getResponse');

  // Make a POST request
  Map<String, dynamic> postResponse = await api.request(
    path: 'posts',
    method: HttpMethod.post,
    body: {'title': 'foo', 'body': 'bar', 'userId': 1},
    jsonParser: jsonParser,
  );

  print('POST response: $postResponse');
}
```

Please note that you need to handle the errors (like `CallApiException`) in a try-catch block in a real-world scenario. Also, you would usually parse the JSON into a more specific data type rather than a `Map<String, dynamic>`.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.