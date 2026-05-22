import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/business.dart';
import '../../data/services/api_service.dart';
import '../../data/services/business_service.dart';

class BusinessDetailsViewModel extends ChangeNotifier {
  BusinessDetailsViewModel({
    required Business initialBusiness,
    BusinessService? businessService,
  }) : business = initialBusiness,
       _businessService = businessService ?? BusinessService();

  final BusinessService _businessService;

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
      business = await _businessService.getBusiness(business.id);
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
