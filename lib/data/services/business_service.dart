import '../models/business.dart';
import 'api_service.dart';

class BusinessService {
  BusinessService({ApiService? api}) : _api = api ?? ApiService.instance;

  final ApiService _api;

  Future<List<Business>> getBusinesses({int skip = 0, int limit = 20}) async {
    final data = await _api.get(
      '/api/v1/businesses/',
      queryParameters: {'skip': skip, 'limit': limit},
    );

    return _parseBusinessList(data);
  }

  Future<List<Business>> searchBusinesses(String query) async {
    final data = await _api.get(
      '/api/v1/businesses/search',
      queryParameters: {'q': query.trim()},
    );

    return _parseBusinessList(data);
  }

  Future<Business> getBusiness(String id) async {
    final data = await _api.get('/api/v1/businesses/$id');

    return Business.fromJson(Map<String, dynamic>.from(data as Map));
  }

  List<Business> _parseBusinessList(dynamic data) {
    if (data is! List) {
      return <Business>[];
    }

    return data
        .whereType<Map>()
        .map(
          (business) => Business.fromJson(Map<String, dynamic>.from(business)),
        )
        .toList();
  }
}
