import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/business.dart';
import '../../data/models/event.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/services/api_service.dart';

class EventDetailsViewModel extends ChangeNotifier {
  EventDetailsViewModel({
    required this.event,
    BusinessRepository? businessRepository,
  }) : _businessRepository = businessRepository ?? BusinessRepository.instance;

  final Event? event;
  final BusinessRepository _businessRepository;

  final List<Business> businesses = [];
  bool isLoading = false;
  String? error;

  bool get hasBusinessIds => event?.businessIds.isNotEmpty ?? false;

  Future<void> loadBusinesses() async {
    final businessIds = event?.businessIds ?? [];
    if (businessIds.isEmpty) {
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final loadedBusinesses = await Future.wait(
        businessIds.map(_businessRepository.fetchBusiness),
      );
      businesses
        ..clear()
        ..addAll(loadedBusinesses);
    } on ApiException catch (exception) {
      error = exception.message;
    } catch (_) {
      error = 'No se pudieron cargar los negocios.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
