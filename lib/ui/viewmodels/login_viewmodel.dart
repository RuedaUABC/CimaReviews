import 'package:flutter/foundation.dart';

import '../../data/repositories/user_repository.dart';
import '../../data/services/api_service.dart';

class LoginViewModel extends ChangeNotifier {
  LoginViewModel({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  String email = '';
  String password = '';
  bool isLoading = false;
  bool rememberMe = true;
  String? errorMessage;

  Future<bool> login() async {
    if (!validateForm()) {
      return false;
    }

    _setLoading(true);
    try {
      await _userRepository.login(email, password);
      errorMessage = null;
      return true;
    } on ApiException catch (error) {
      errorMessage = error.message;
      return false;
    } catch (_) {
      errorMessage =
          'No se pudo iniciar sesion. Revisa la API e intentalo de nuevo.';
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithBiometrics() async {
    errorMessage = 'El inicio con biometria aun no esta disponible.';
    notifyListeners();
    return false;
  }

  bool validateForm() {
    clearError();

    if (email.trim().isEmpty || password.isEmpty) {
      errorMessage = 'Ingresa correo y contrasena.';
    } else if (!_isValidEmail(email)) {
      errorMessage = 'Ingresa un correo valido.';
    }

    notifyListeners();
    return errorMessage == null;
  }

  void clearError() {
    errorMessage = null;
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());
  }
}
