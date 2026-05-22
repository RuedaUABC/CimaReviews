import '../models/event.dart';
import 'api_service.dart';

class EventService {
  EventService({ApiService? api}) : _api = api ?? ApiService.instance;

  final ApiService _api;

  Future<List<Event>> getEvents({int skip = 0, int limit = 20}) async {
    final data = await _api.get(
      '/api/v1/events/',
      queryParameters: {'skip': skip, 'limit': limit},
    );

    if (data is! List) {
      return <Event>[];
    }

    return data
        .whereType<Map>()
        .map((event) => Event.fromJson(Map<String, dynamic>.from(event)))
        .toList();
  }
}
