import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/event.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/services/business_service.dart';
import 'package:cimareviews/data/services/event_service.dart';
import 'package:cimareviews/ui/viewmodels/business_details_viewmodel.dart';
import 'package:cimareviews/ui/viewmodels/events_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('EventsViewModel', () {
    test('loads events from EventService', () async {
      final event = Event(
        id: 'evt_1',
        title: 'Noche de Tacos',
        date: DateTime(2026, 6, 1),
        businessIds: ['biz_1'],
      );
      final viewModel = EventsViewModel(
        eventService: _FakeEventService(events: [event]),
      );

      await viewModel.loadEvents();

      expect(viewModel.error, isNull);
      expect(viewModel.events.single.title, 'Noche de Tacos');
    });
  });

  group('BusinessDetailsViewModel', () {
    test('loads full business details by id', () async {
      final summary = _business('biz_1', 'Resumen', []);
      final detail = _business('biz_1', 'Detalle completo', [Category.tacos]);
      final viewModel = BusinessDetailsViewModel(
        initialBusiness: summary,
        businessService: _FakeBusinessService(detail: detail),
      );

      await viewModel.loadDetails();

      expect(viewModel.error, isNull);
      expect(viewModel.business.name, 'Detalle completo');
      expect(viewModel.business.categories, [Category.tacos]);
    });
  });
}

class _FakeEventService extends EventService {
  _FakeEventService({required this.events});

  final List<Event> events;

  @override
  Future<List<Event>> getEvents({int skip = 0, int limit = 20}) async {
    return events;
  }
}

class _FakeBusinessService extends BusinessService {
  _FakeBusinessService({required this.detail});

  final Business detail;

  @override
  Future<Business> getBusiness(String id) async {
    return detail;
  }
}

Business _business(String id, String name, List<Category> categories) {
  return Business(
    id: id,
    name: name,
    owner: User(id: 'owner_$id', name: 'Owner', email: '', role: Seller()),
    location: const LatLng(32.52, -116.98),
    avgRating: 4.5,
    products: [],
    reviews: [],
    categories: categories,
  );
}
