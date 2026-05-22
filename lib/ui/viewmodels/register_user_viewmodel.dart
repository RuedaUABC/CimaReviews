import 'package:flutter/foundation.dart';

import '../../data/services/api_service.dart';
import '../../data/services/auth_service.dart';

class RegisterUserViewModel extends ChangeNotifier {
  RegisterUserViewModel({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool seller = false;
  bool isLoading = false;
  List<String> errors = [];

  Future<bool> register() async {
    errors = validateForm();
    notifyListeners();

    if (errors.isNotEmpty) {
      return false;
    }

    _setLoading(true);
    try {
      await _authService.register(name, email, password);
      errors = [];
      return true;
    } on ApiException catch (error) {
      errors = [error.message];
      return false;
    } catch (_) {
      errors = [
        'No se pudo completar el registro. Revisa la API e intentalo de nuevo.',
      ];
      return false;
    } finally {
      _setLoading(false);
    }
  }

  List<String> validateForm() {
    final result = <String>[];

    if (name.trim().isEmpty) {
      result.add('Ingresa tu nombre.');
    }
    if (email.trim().isEmpty) {
      result.add('Ingresa tu correo.');
    } else if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim())) {
      result.add('Ingresa un correo valido.');
    }
    if (password.length < 8) {
      result.add('La contrasena debe tener al menos 8 caracteres.');
    }
    if (password != confirmPassword) {
      result.add('Las contrasenas no coinciden.');
    }

    return result;
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
