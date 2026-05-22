import 'api_transport_response.dart';

Future<ApiTransportResponse> sendJsonRequest({
  required Uri uri,
  required String method,
  required Map<String, String> headers,
  Object? body,
}) {
  throw UnsupportedError('No HTTP transport is available on this platform.');
}
