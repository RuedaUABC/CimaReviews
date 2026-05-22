import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/event.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/services/api_service.dart';

class EventsViewModel extends ChangeNotifier {
  EventsViewModel({EventRepository? eventRepository})
    : _eventRepository = eventRepository ?? EventRepository();

  final EventRepository _eventRepository;

  List<Event> events = [];
  bool isLoading = false;
  String? error;

  Future<void> loadEvents() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      events = await _eventRepository.fetchEvents(limit: 100);
    } on ApiException catch (exception) {
      error = exception.message;
    } catch (_) {
      error =
          'No se pudieron cargar los eventos. Revisa la API e intentalo de nuevo.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() => loadEvents();
}
