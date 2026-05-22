import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/event.dart';
import '../../data/services/api_service.dart';
import '../../data/services/event_service.dart';

class EventsViewModel extends ChangeNotifier {
  EventsViewModel({EventService? eventService})
    : _eventService = eventService ?? EventService();

  final EventService _eventService;

  List<Event> events = [];
  bool isLoading = false;
  String? error;

  Future<void> loadEvents() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      events = await _eventService.getEvents(limit: 100);
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
