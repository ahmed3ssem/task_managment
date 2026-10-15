abstract class ApiConsumer {
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParams,
    required Map<String, String> body,
  });

  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? queryParams,
    dynamic body,
  });

  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? queryParams,
    Map<String, dynamic>? body,
  });
}
