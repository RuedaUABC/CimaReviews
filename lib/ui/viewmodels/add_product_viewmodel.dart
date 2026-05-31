import 'package:flutter/foundation.dart' show ChangeNotifier;

import '../../data/models/business.dart';
import '../../data/models/product.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/user_repository.dart';

class AddProductViewModel extends ChangeNotifier {
  AddProductViewModel({
    required this.business,
    BusinessRepository? businessRepository,
    UserRepository? userRepository,
  }) : _businessRepository = businessRepository ?? BusinessRepository.instance,
       _userRepository = userRepository ?? UserRepository();

  final Business business;
  final BusinessRepository _businessRepository;
  final UserRepository _userRepository;

  String name = '';
  String price = '';
  String description = '';
  bool isLoading = false;
  List<String> errors = [];
  Product? createdProduct;

  void updateName(String value) => name = value;

  void updatePrice(String value) => price = value;

  void updateDescription(String value) => description = value;

  List<String> validateForm() {
    final validationErrors = <String>[];

    if (name.trim().isEmpty) {
      validationErrors.add('Ingresa el nombre del producto.');
    }

    final parsedPrice = _parsePrice();
    if (parsedPrice == null || parsedPrice <= 0) {
      validationErrors.add('Ingresa un precio valido.');
    }

    errors = validationErrors;
    notifyListeners();
    return errors;
  }

  Future<bool> addProduct() async {
    if (validateForm().isNotEmpty) {
      return false;
    }

    final user = _userRepository.getCurrentSession()?.user;
    if (user == null) {
      errors = ['Inicia sesion para agregar productos.'];
      notifyListeners();
      return false;
    }

    if (user.id != business.owner.id) {
      errors = ['Solo el dueno del negocio puede agregar productos.'];
      notifyListeners();
      return false;
    }

    _setLoading(true);
    try {
      final product = Product(
        name: name.trim(),
        price: _parsePrice()!,
        description: description.trim().isEmpty ? null : description.trim(),
      );

      await _businessRepository.addProduct(business.id, product);
      createdProduct = product;
      errors = [];
      return true;
    } catch (_) {
      errors = ['No se pudo agregar el producto. Intentalo de nuevo.'];
      return false;
    } finally {
      _setLoading(false);
    }
  }

  double? _parsePrice() {
    return double.tryParse(price.trim().replaceAll(',', '.'));
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
