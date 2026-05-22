import 'package:flutter/foundation.dart';

import '../../data/models/role.dart';
import '../../data/models/user.dart';
import '../../data/services/auth_service.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserProfileViewModel({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  User? user;
  bool isLoading = false;
  String? error;

  void loadCurrentUser() {
    isLoading = true;
    error = null;
    notifyListeners();

    final session = _authService.getCurrentSession();
    if (session == null || !session.isValid()) {
      user = null;
      error = 'No hay una sesion activa.';
    } else {
      user = session.user;
    }

    isLoading = false;
    notifyListeners();
  }

  String get displayName {
    final name = user?.name.trim();
    if (name == null || name.isEmpty) {
      return 'Usuario';
    }
    return name;
  }

  String get displayRole {
    final roles = user?.roles;
    if (roles == null || roles.isEmpty) {
      return 'Cliente';
    }

    return roles.map(roleDisplayName).join(', ');
  }
}
