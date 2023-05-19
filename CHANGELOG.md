## Changelog

### 1.0.0

- Initial version.
- Supports GET, POST, PUT, PATCH, and DELETE HTTP methods.
- Provides a method to parse the JSON response from the server into a custom data type.
- Includes error handling functionality, throwing an `CallApiException` whenever an error occurs during an API call.
- Implemented as a singleton to ensure only one instance exists for each base URL, allowing for efficient reuse of the instances across the application.
