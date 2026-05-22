import 'dart:convert';
import 'dart:io';

import 'api_transport_response.dart';

Future<ApiTransportResponse> sendJsonRequest({
  required Uri uri,
  required String method,
  required Map<String, String> headers,
  Object? body,
}) async {
  final client = HttpClient();
  try {
    final request = await client.openUrl(method, uri);
    headers.forEach(request.headers.set);

    if (body != null) {
      request.write(jsonEncode(body));
    }

    final response = await request.close();
    final responseBody = await utf8.decoder.bind(response).join();

    return ApiTransportResponse(
      statusCode: response.statusCode,
      body: responseBody,
    );
  } finally {
    client.close(force: true);
  }
}
