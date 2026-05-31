import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:latlong2/latlong.dart';

import '../../data/models/business.dart';
import '../../data/models/category.dart';
import '../../data/models/permission.dart';
import '../../data/models/user.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/user_repository.dart';

class RegisterBusinessViewModel extends ChangeNotifier {
  RegisterBusinessViewModel({
    BusinessRepository? businessRepository,
    UserRepository? userRepository,
  }) : _businessRepository = businessRepository ?? BusinessRepository.instance,
       _userRepository = userRepository ?? UserRepository();

  final BusinessRepository _businessRepository;
  final UserRepository _userRepository;

  String name = '';
  String description = '';
  String latitude = '';
  String longitude = '';
  String imageUrl = '';
  Category? selectedCategory;
  bool isLoading = false;
  List<String> errors = [];
  Business? createdBusiness;

  void updateName(String value) => name = value;

  void updateDescription(String value) => description = value;

  void updateLatitude(String value) => latitude = value;

  void updateLongitude(String value) => longitude = value;

  void updateImageUrl(String value) => imageUrl = value;

  void selectCategory(Category? value) {
    selectedCategory = value;
    notifyListeners();
  }

  List<String> validateForm() {
    final validationErrors = <String>[];

    if (name.trim().isEmpty) {
      validationErrors.add('Ingresa el nombre del negocio.');
    }

    if (selectedCategory == null) {
      validationErrors.add('Selecciona una categoria.');
    }

    final parsedLatitude = double.tryParse(latitude.trim());
    if (parsedLatitude == null || parsedLatitude < -90 || parsedLatitude > 90) {
      validationErrors.add('Ingresa una latitud valida.');
    }

    final parsedLongitude = double.tryParse(longitude.trim());
    if (parsedLongitude == null ||
        parsedLongitude < -180 ||
        parsedLongitude > 180) {
      validationErrors.add('Ingresa una longitud valida.');
    }

    errors = validationErrors;
    notifyListeners();
    return errors;
  }

  Future<bool> registerBusiness() async {
    if (validateForm().isNotEmpty) {
      return false;
    }

    final user = _currentUser;
    if (user == null) {
      errors = ['Inicia sesion para registrar un negocio.'];
      notifyListeners();
      return false;
    }

    if (!_canCreateBusiness(user)) {
      errors = ['No tienes permiso para registrar negocios.'];
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      final now = DateTime.now();
      final business = Business(
        id: 'local_business_${user.id}_${now.microsecondsSinceEpoch}',
        name: name.trim(),
        owner: user,
        location: LatLng(
          double.parse(latitude.trim()),
          double.parse(longitude.trim()),
        ),
        avgRating: 0,
        products: [],
        reviews: [],
        categories: [selectedCategory!],
        description: description.trim().isEmpty ? null : description.trim(),
        imageUrl: imageUrl.trim().isEmpty ? null : imageUrl.trim(),
      );

      createdBusiness = await _businessRepository.createBusiness(business);
      errors = [];
      return true;
    } catch (_) {
      errors = ['No se pudo registrar el negocio. Intentalo de nuevo.'];
      return false;
    } finally {
      _setLoading(false);
    }
  }

  User? get _currentUser => _userRepository.getCurrentSession()?.user;

  bool _canCreateBusiness(User user) {
    return user.roles.any(
      (role) => role.hasPermission(Permission.createBusiness),
    );
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
