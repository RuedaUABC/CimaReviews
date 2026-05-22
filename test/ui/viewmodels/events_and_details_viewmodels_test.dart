import 'package:cimareviews/data/models/business.dart';
import 'package:cimareviews/data/models/category.dart';
import 'package:cimareviews/data/models/event.dart';
import 'package:cimareviews/data/models/role.dart';
import 'package:cimareviews/data/models/user.dart';
import 'package:cimareviews/data/repositories/business_repository.dart';
import 'package:cimareviews/data/repositories/event_repository.dart';
import 'package:cimareviews/ui/viewmodels/business_details_viewmodel.dart';
import 'package:cimareviews/ui/viewmodels/events_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('EventsViewModel', () {
    test('loads events from EventRepository', () async {
      final event = Event(
        id: 'evt_1',
        title: 'Noche de Tacos',
        date: DateTime(2026, 6, 1),
        businessIds: ['biz_1'],
      );
      final viewModel = EventsViewModel(
        eventRepository: _FakeEventRepository(items: [event]),
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
        businessRepository: _FakeBusinessRepository(detail: detail),
      );

      await viewModel.loadDetails();

      expect(viewModel.error, isNull);
      expect(viewModel.business.name, 'Detalle completo');
      expect(viewModel.business.categories, [Category.tacos]);
    });
  });
}

class _FakeEventRepository extends EventRepository {
  _FakeEventRepository({required this.items});

  final List<Event> items;

  @override
  Future<List<Event>> fetchEvents({int skip = 0, int limit = 20}) async {
    return items;
  }
}

class _FakeBusinessRepository extends BusinessRepository {
  _FakeBusinessRepository({required this.detail});

  final Business detail;

  @override
  Future<Business> fetchBusiness(String id) async {
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
