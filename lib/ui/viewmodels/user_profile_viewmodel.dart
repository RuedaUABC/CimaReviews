import 'package:flutter/foundation.dart';

import '../../data/models/role.dart';
import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

class UserProfileViewModel extends ChangeNotifier {
  UserProfileViewModel({UserRepository? userRepository})
    : _userRepository = userRepository ?? UserRepository();

  final UserRepository _userRepository;

  User? user;
  bool isLoading = false;
  String? error;

  void loadCurrentUser() {
    isLoading = true;
    error = null;
    notifyListeners();

    final session = _userRepository.getCurrentSession();
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

  Future<void> logout() {
    return _userRepository.logout();
  }
}
