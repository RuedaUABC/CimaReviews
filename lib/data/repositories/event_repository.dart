import '../models/event.dart';
import '../services/event_service.dart';
import 'business_repository.dart';

class EventRepository {
  EventRepository({EventService? service, List<Event>? seedEvents})
    : _service = service ?? EventService(),
      events = seedEvents ?? _mockEvents();

  final EventService _service;
  final List<Event> events;

  Future<List<Event>> fetchEvents({int skip = 0, int limit = 20}) async {
    final remoteEvents = await _service.getEvents(skip: skip, limit: limit);
    events
      ..clear()
      ..addAll(remoteEvents);
    return remoteEvents;
  }

  List<Event> getLocalEvents() => events;

  static List<Event> _mockEvents() {
    return [
      Event(
        id: '1',
        title: 'Evento de comida',
        participants: BusinessRepository.instance.getLocalBusinesses(),
      ),
      Event(id: '2', title: 'Evento de tecnologia', participants: []),
    ];
  }
}
