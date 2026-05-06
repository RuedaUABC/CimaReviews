import 'package:cimareviews/data/repositories/business_repository.dart';

import '../models/event.dart';

class EventRepository {
  List<Event> events = [
    Event(
      id: '1',
      title: 'Evento de comida',
      participants: BusinessRepository.instance.getBusinesses(),
    ),
    Event(
      id: '2',
      title: 'Evento de tecnología',
      participants: [],
    ),
  ];

  List<Event> getEvents() {
    // TODO: devolver lista de eventos
    return events;
  }
}