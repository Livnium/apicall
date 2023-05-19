import 'dart:convert';

import 'package:callapi/callapi.dart';

void main() async {
  // Create an ApiCall instance for a specific base URL
  CallApi apiCall = CallApi(baseUrl: 'https://jsonplaceholder.typicode.com/');

  // Define a function to parse a JSON string into a Map
  Map<String, dynamic> jsonParser(String jsonString) {
    return jsonDecode(jsonString);
  }

  // Make a GET request
  Map<String, dynamic> getResponse = await apiCall.request(
    path: 'posts/1',
    method: HttpMethod.get,
    jsonParser: jsonParser,
  );

  print('GET response: $getResponse');

  // Make a POST request
  Map<String, dynamic> postResponse = await apiCall.request(
    path: 'posts',
    method: HttpMethod.post,
    body: {'title': 'foo', 'body': 'bar', 'userId': 1},
    jsonParser: jsonParser,
  );

  print('POST response: $postResponse');
}
