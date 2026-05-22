import 'dart:convert';

import 'package:cimareviews/utils/constants.dart';

import 'api_transport.dart';

class ApiException implements Exception {
  ApiException(this.message, {this.statusCode, this.details});

  final String message;
  final int? statusCode;
  final Object? details;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({String baseUrl = AppConstants.apiBaseUrl}) : _baseUrl = baseUrl;

  static final ApiService instance = ApiService();

  final String _baseUrl;
  String? _token;

  void setToken(String token) {
    _token = token;
  }

  void clearToken() {
    _token = null;
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request('GET', endpoint, queryParameters: queryParameters);
  }

  Future<dynamic> post(String endpoint, {Object? body}) {
    return _request('POST', endpoint, body: body);
  }

  Future<dynamic> put(String endpoint, {Object? body}) {
    return _request('PUT', endpoint, body: body);
  }

  Future<dynamic> patch(String endpoint, {Object? body}) {
    return _request('PATCH', endpoint, body: body);
  }

  Future<void> delete(String endpoint) async {
    await _request('DELETE', endpoint);
  }

  Future<dynamic> _request(
    String method,
    String endpoint, {
    Object? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await sendJsonRequest(
      uri: _uriFor(endpoint, queryParameters),
      method: method,
      headers: _buildHeaders(),
      body: body,
    );

    return _handleResponse(response);
  }

  Map<String, String> _buildHeaders() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (_token != null && _token!.isNotEmpty)
        'Authorization': 'Bearer $_token',
    };
  }

  Uri _uriFor(String endpoint, Map<String, dynamic>? queryParameters) {
    final base = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final uri = Uri.parse('$base$endpoint');

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  dynamic _handleResponse(ApiTransportResponse response) {
    final decoded = _decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw ApiException(
      _errorMessage(decoded) ?? 'Error de servidor (${response.statusCode}).',
      statusCode: response.statusCode,
      details: decoded,
    );
  }

  String? _errorMessage(dynamic decoded) {
    if (decoded is Map<String, dynamic>) {
      final detail = decoded['detail'];
      if (detail is String) {
        return detail;
      }
      if (detail is List && detail.isNotEmpty) {
        final first = detail.first;
        if (first is Map && first['msg'] != null) {
          return first['msg'].toString();
        }
      }
      if (decoded['message'] != null) {
        return decoded['message'].toString();
      }
    }
    return null;
  }

  dynamic _decode(String body) {
    if (body.isEmpty) {
      return null;
    }

    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }
}
