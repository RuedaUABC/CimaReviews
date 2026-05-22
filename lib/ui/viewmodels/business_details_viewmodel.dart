import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/business.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/services/api_service.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  BusinessDetailsViewModel({
    required Business initialBusiness,
    BusinessRepository? businessRepository,
  }) : business = initialBusiness,
       _businessRepository = businessRepository ?? BusinessRepository.instance;

  final BusinessRepository _businessRepository;

  Business business;
  bool isLoading = false;
  String? error;

  Future<void> loadDetails() async {
    if (business.id.isEmpty) {
      return;
    }

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      business = await _businessRepository.fetchBusiness(business.id);
    } on ApiException catch (exception) {
      error = exception.message;
    } catch (_) {
      error = 'No se pudo cargar el detalle del negocio.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
